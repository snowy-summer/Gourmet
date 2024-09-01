//
//  ProfileViewModel.swift
//  Gourmet
//
//  Created by 최승범 on 8/31/24.
//

import Foundation
import RxSwift
import RxCocoa

final class ProfileViewModel: ViewModelProtocol {
    
    enum Input {
        case noValue
        case viewDidLoad
        case selectMode(Int)
    }
    
    enum Output {
        case noValue
        case viewDidLoad
        case needReLogin
    }
    
    enum Item: Hashable {
        case profile(UserDTO)
        case normal(String)
    }
    
    enum NetworkType {
        case fetchProfile
        case withdraw
    }
  
    private let networkManager: NetworkManagerProtocol
    private(set) var profile = [Item]()
    private(set) var output = BehaviorSubject(value: Output.noValue)
    private(set) var settingList: [Item] = [
        .normal("로그아웃"),
        .normal("탈퇴하기")
    ]
    
    init(networkManager: NetworkManagerProtocol) {
        self.networkManager = networkManager
    }
    
    func apply(_ input: Input) {
        
        switch input {
        case .noValue:
            return
            
        case .viewDidLoad:
            fetchProfile()
            
        case .selectMode(let index):
            if index == 0 {
                output.onNext(.needReLogin)
            } else {
                withdraw()
            }
        }
    }
    
    func transform(_ input: Input) -> Output {
        return Output.noValue
    }
}

extension ProfileViewModel {
    
    private func fetchProfile() {
        
        networkManager.fetchProfile { [weak self] result in
            guard let self = self else { return }
            switch result {
            case .success(let data):
                profile = [.profile(data)]
                output.onNext(.viewDidLoad)
                
            case .failure(let error):
                if error == .expiredAccessToken {
                    refreshAccessToken(type: .fetchProfile)
                } else {
                    PrintDebugger.logError(error)
                }
                
            }
        }
    }
    
    private func withdraw() {
        
        networkManager.withdraw { [weak self] result in
            guard let self = self else { return }
            switch result {
            case .success:
                output.onNext(.needReLogin)
                
            case .failure(let error):
                if error == .expiredAccessToken {
                    refreshAccessToken(type: .withdraw)
                } else {
                    PrintDebugger.logError(error)
                }
                
            }
        }
    }
    
    private func refreshAccessToken(type: NetworkType) {
        
        networkManager.refreshAccessToken {[weak self] result in
            guard let self = self else { return }
            switch result {
            case .success:
                if type == .fetchProfile {
                    fetchProfile()
                } else {
                    withdraw()
                }
               
            case .failure(let error):
                PrintDebugger.logError(error)
                output.onNext(.needReLogin)
            }
        }
    }
}
