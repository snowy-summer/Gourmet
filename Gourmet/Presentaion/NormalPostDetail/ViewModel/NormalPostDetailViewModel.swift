//
//  NormalPostDetailViewModel.swift
//  Gourmet
//
//  Created by 최승범 on 8/30/24.
//

import Foundation
import RxSwift
import RxCocoa

final class NormalPostDetailViewModel: ViewModelProtocol {
    
    enum Input {
        case noValue
        case reloadView
        case uploadComment(String?)
    }
    
    enum Output {
        case noValue
        case reloadView(PostDTO)
        case needReLogin
    }
    
    enum Item: Hashable {
        case main(PostDTO)
        case comment(CommentDTO)
    }
    
    private let networkManager: NetworkManagerProtocol
    private(set) var output = BehaviorSubject(value: Output.noValue)
    private var postId = ""
    
    init(networkManager: NetworkManagerProtocol) {
        self.networkManager = networkManager
    }
    
    func apply(_ input: Input) {
        
        switch input {
        case .noValue:
            return
            
        case .reloadView:
            fetchPost()
            
        case .uploadComment(let string):
            return
        }
    }
    
    func transform(_ input: Input) -> Output {
        return Output.noValue
    }
}

extension NormalPostDetailViewModel {
    
    func getPostId(_ id: String) {
        postId = id
    }
    
    private func fetchPost() {
        
        networkManager.fetchPostById(id: postId) { [weak self] result in
            guard let self = self else { return }
            switch result {
            case .success(let data):
//                normalPostList = data.data
                output.onNext(.reloadView(data))
                return
                
            case .failure(let error):
                if error == .expiredAccessToken {
                    refreshAccessToken()
                } else {
                    PrintDebugger.logError(error)
                }
                
            }
        }
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
