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
    
    private let networkManager = NetworkManager()
    private var nextCursor = ""
    private let disposeBag = DisposeBag()
    
    func transform(_ input: Input) -> Output {
        
        let items = PublishSubject<[PostDTO]>()
        let needReLogin = PublishSubject<Bool>()
        
        input.reload
            .flatMapLatest { [weak self] _ -> Single<Result<PostListDTO, PostError>> in
                guard let self = self else { return .just(.failure(.forbidden)) }
                return networkManager.fetchNormalPost(next: nextCursor)
            }
            .bind(with: self) { owner, value in
                
                switch value {
                case .success(let data):
                    items.onNext(data.data)
                    owner.nextCursor = data.nextCursor
                    
                case .failure(let error):
                    if error == .expiredAccessToken {
                        let isSuccess = owner.networkManager.refreshAccessToken().asObservable()
                        owner.refreshToken(isSuccess: isSuccess,
                                     items: items,
                                     needReLogin: needReLogin)
                        
                    } else {
                        needReLogin.onNext(false)
                    }
                    
                }
            }
            .disposed(by: disposeBag)
        
        return Output(items: items,
                      needReLogin: needReLogin)
    }
    
    private func refreshToken(isSuccess: Observable<Bool>,
                              items: PublishSubject<[PostDTO]>,
                              needReLogin: PublishSubject<Bool>) {
        
        isSuccess
            .flatMapLatest { [weak self] value -> Single<Result<PostListDTO, PostError>> in
                guard let self = self else { return .just(.failure(.forbidden)) }
                if value {
                    return networkManager.fetchNormalPost(next: nextCursor)
                } else {
                    return .just(.failure(.forbidden))
                }
                
            }
            .bind(with: self) { owner, value in
                
                switch value {
                case .success(let data):
                    items.onNext(data.data)
                    owner.nextCursor = data.nextCursor
                    
                case .failure:
                    needReLogin.onNext(true)
                }
            }.disposed(by: disposeBag)
    }
}
