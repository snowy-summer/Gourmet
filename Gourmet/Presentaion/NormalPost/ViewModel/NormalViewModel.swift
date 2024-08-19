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
    }
    
    private let networkManager = NetworkManager()
    private var nextCursor = ""
    private let disposeBag = DisposeBag()
    
    func transform(_ input: Input) -> Output {
        
        let items = PublishSubject<[PostDTO]>()
        
        input.reload
            .flatMapLatest { [weak self] _ -> Single<Result<PostListDTO, PostError>> in
                guard let self = self else { return .just(.failure(.forbidden)) }
                return self.networkManager.fetchNormalPost(next: self.nextCursor)
            }
            .bind(with: self) { owner,value in
                
                switch value {
                case .success(let data):
                    items.onNext(data.data)
                    owner.nextCursor = data.nextCursor
                    
                case .failure(let error):
                    if error == .expiredAccessToken {
                        owner.networkManager.refreshAccessToken()
                    }
                }
            }
            .disposed(by: disposeBag)
        
        return Output(items: items)
    }
}
