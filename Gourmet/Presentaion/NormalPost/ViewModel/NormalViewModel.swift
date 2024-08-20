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
    
    struct Input {
        let reload: Observable<Void>
    }
    
    struct Output {
        let items: PublishSubject<[PostDTO]>
        let needReLogin: PublishSubject<Bool>
    }
    
    private let networkManager: NetworkManagerProtocol
    private var nextCursor = ""
    private let disposeBag = DisposeBag()
    
    init(networkManager: NetworkManagerProtocol) {
        self.networkManager = networkManager
    }
    
    func transform(_ input: Input) -> Output {
        
        let items = PublishSubject<[PostDTO]>()
        let needReLogin = PublishSubject<Bool>()
        
        input.reload
            .flatMapLatest { [weak self] _ -> Single<Result<PostListDTO, PostError>> in
                guard let self = self else { return .just(.failure(.forbidden)) }
                return networkManager.fetchPost(next: nextCursor,
                                                category: "Gourmet_normal")
            }
            .bind(with: self) { owner, value in
                
                switch value {
                case .success(let data):
                    
                    items.onNext(data.data)
                    owner.nextCursor = data.nextCursor
                    
                case .failure(let error):
                    if error == .expiredAccessToken {
                
                        let isSuccess = owner.networkManager.refreshAccessToken()
                        owner.refreshToken(isSuccess: isSuccess,
                                     items: items,
                                     needReLogin: needReLogin)
                        
                    } else {
                        print(error)
                        needReLogin.onNext(true)
                    }
                    
                }
            }
            .disposed(by: disposeBag)
        
        return Output(items: items,
                      needReLogin: needReLogin)
    }
    
    private func refreshToken(isSuccess: Single<Bool>,
                              items: PublishSubject<[PostDTO]>,
                              needReLogin: PublishSubject<Bool>) {
        
        isSuccess.subscribe(with: self) { owner, value in
            if value {
                owner.networkManager.fetchPost(next: owner.nextCursor,
                                               category: "Gourmet_normal")
                    .subscribe(with: self) { owner, result in
                        
                        switch result {
                        case .success(let data):
                            owner.nextCursor = data.nextCursor
                            items.onNext(data.data)
                            
                        case .failure:
                            needReLogin.onNext(true)
                        }
                    }.disposed(by: owner.disposeBag)
                    
            } else {
                needReLogin.onNext(true)
            }
        }.disposed(by: disposeBag)
    }
}
