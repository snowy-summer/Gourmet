//
//  NormalViewModel.swift
//  Gourmet
//
//  Created by 최승범 on 8/18/24.
//

import Foundation
import RxSwift
import RxCocoa

final class NormalViewModel: ViewModelProtocol {
    
    enum Input {
        case noValue
        case refreshData
    }
    
    enum Output {
        case noValue
        case reloadView([PostDTO])
        case needReLogin
    }
    
    private let networkManager: NetworkManagerProtocol
    
    private(set)var output = BehaviorSubject(value: Output.noValue)
    private var normalPostList = [PostDTO]()
    private var category = Category(id: .normal)
    private let disposeBag = DisposeBag()
    
    init(networkManager: NetworkManagerProtocol) {
        self.networkManager = networkManager
    }
    
    func apply(_ input: Input) {
        
        switch input {
        case .noValue:
            return
            
        case .refreshData:
            fetchPost()
        }
    }
    
    func transform(_ input: Input) -> Output {
        return Output.noValue
    }
    
    private func fetchPost() {
        
        networkManager.fetchPost(category: category)
            .subscribe(with: self) { owner, result in
                
                switch result {
                case .success(let data):
                    owner.normalPostList = data.data
                    owner.category.nextCursor = data.nextCursor
                    owner.output.onNext(.reloadView(owner.normalPostList))
                    
                case .failure(let error):
                    if error == .expiredAccessToken {
                        owner.refreshAccessToken()
                    } else {
                        PrintDebugger.logError(error)
                    }
                    
                }
            }
            .disposed(by: disposeBag)
    }
    
    private func refreshAccessToken() {
        
        networkManager.refreshAccessToken {[weak self] result in
            guard let self = self else { return }
            switch result {
            case .success:
                fetchPost()
                return
                
            case .failure(let error):
                PrintDebugger.logError(error)
                output.onNext(.needReLogin)
            }
        }
    }
}
