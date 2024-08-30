//
//  RecipeCollectionViewModel.swift
//  Gourmet
//
//  Created by 최승범 on 8/30/24.
//

import Foundation
import RxSwift

final class RecipeCollectionViewModel: ViewModelProtocol {
    
    enum Input {
        case noValue
        case requestImage(String)
    }
    
    enum Output {
        case noValue
        case fetchImage(Data)
        case needReLogin
    }
    
    private(set)var output = BehaviorSubject(value: Output.noValue)
    private var filePath = ""
    private let networkManager: NetworkManagerProtocol
    private let disposeBag = DisposeBag()
    
    init(networkManger: NetworkManagerProtocol) {
        self.networkManager = networkManger
        
    }
    
    func apply(_ input: Input) {
        
        switch input {
        case .noValue:
            return
            
        case .requestImage(let filePath):
            self.filePath = filePath
            fetchImage()
        }
    }
    
    func transform(_ input: Input) -> Output {
        
        return Output.noValue
    }
    
    private func fetchImage() {
        NetworkManager.shared.fetchImage(file: filePath) { [weak self] result in
            guard let self = self else { return }
            switch result {
            case .success(let data):
                if let data = data {
                    output.onNext(.fetchImage(data))
                }

            case .failure(let failure):
                refreshAccessToken()
            }
        }
    }
    
    private func refreshAccessToken() {
        
        networkManager.refreshAccessToken {[weak self] result in
            guard let self = self else { return }
            switch result {
            case .success:
                fetchImage()
                
            case .failure(let error):
                PrintDebugger.logError(error)
                output.onNext(.needReLogin)
            }
        }
    }
}
