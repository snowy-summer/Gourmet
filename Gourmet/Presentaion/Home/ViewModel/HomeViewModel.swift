//
//  HomeViewModel.swift
//  Gourmet
//
//  Created by 최승범 on 8/20/24.
//

import Foundation
import RxSwift
import RxCocoa

final class HomeViewModel: ViewModelProtocol {
    
    struct Input {
        let reload: Observable<Void>
    }
    
    struct Output {
        let sections: Observable<[HomeViewSectionModel]>
        let needReLogin: PublishSubject<Bool>
    }
    
    private let networkManager: NetworkManagerProtocol
    
    private var firstCategory = Category(id: .main)
    private var secondCategory = Category(id: .appetizer)
    private var thirdCategory = Category(id: .dessert)
    
    private let sections = PublishSubject<[HomeViewSectionModel]>()
    private let disposeBag = DisposeBag()
    
    init(networkManager: NetworkManagerProtocol) {
        self.networkManager = networkManager
    }
    
    func transform(_ input: Input) -> Output {
        let needReLogin = PublishSubject<Bool>()
        
        // TODO: - 데이터 패치전에 토큰 갱신을 한 번 하고 진행으로 변경하기
        
        let group = DispatchGroup()
        
        group.enter()
        refreshAccessToken(needReLogin: needReLogin,
                           group: group)
        
        group.notify(queue: DispatchQueue.global()) { [weak self] in
            guard let self = self else { return }
            fetchSections(signal: input.reload,
                          needReLogin: needReLogin)
            .bind(to: sections)
            .disposed(by: disposeBag)
        }
        
        return Output(sections: sections.asObservable(),
                      needReLogin: needReLogin)
    }
    
    private func refreshAccessToken(needReLogin: PublishSubject<Bool>,
                                    group: DispatchGroup ) {
        
        networkManager.refreshAccessToken { result in
            switch result {
            case .success:
                group.leave()
                return
                
            case .failure(let error):
                PrintDebugger.logError(error)
                needReLogin.onNext(true)
                group.leave()
            }
        }
    }
    
    private func fetchSections(signal: Observable<Void>,
                               needReLogin: PublishSubject<Bool>) -> Observable<[HomeViewSectionModel]> {
        
        let firstRequest = createPostRequest(signal: signal,
                                             category: firstCategory)
        let secondRequest = createPostRequest(signal: signal,
                                              category: secondCategory)
        let thirdRequest = createPostRequest(signal: signal,
                                             category: thirdCategory)
        
        return Observable.zip(firstRequest, secondRequest, thirdRequest)
            .map { [weak self] firstResult, secondResult, thirdResult in
                guard let self = self else { return [] }
                
                var sections = [HomeViewSectionModel]()
                
                handleResult(result: firstResult,
                             category: &firstCategory,
                             sections: &sections,
                             needReLogin: needReLogin)
                handleResult(result: secondResult,
                             category: &secondCategory,
                             sections: &sections,
                             needReLogin: needReLogin)
                handleResult(result: thirdResult,
                             category: &thirdCategory,
                             sections: &sections,
                             needReLogin: needReLogin)
                
                return sections
            }
    }
    
    private func createPostRequest(signal: Observable<Void>,
                                   category: Category) -> Observable<Result<PostListDTO, PostError>> {
        return signal
            .flatMapLatest { [weak self] _ -> Single<Result<PostListDTO, PostError>> in
                guard let self = self else { return .just(.failure(.forbidden)) }
                
                return self.networkManager.fetchPost(category: category)
            }
            .asObservable()
    }
    
    private func handleResult(result: Result<PostListDTO, PostError>,
                              category: inout Category,
                              sections: inout [HomeViewSectionModel],
                              needReLogin: PublishSubject<Bool>) {
        
        switch result {
        case .success(let data):
            let section = HomeViewSectionModel(header: category.id.name,
                                               items: data.data)
            sections.append(section)
            category.nextCursor = data.nextCursor
            
        case .failure(let error):
            PrintDebugger.logError(error)
            handleFailure(error: error,
                          needReLogin: needReLogin)
        }
    }
    
    private func handleFailure(error: PostError,
                               needReLogin: PublishSubject<Bool>) {
        if error == .expiredAccessToken {
            
            networkManager.refreshAccessToken { [weak self] result in
                guard let self = self else { return }
                switch result {
                case .success:
                    fetchSections(signal: Observable.just(()),
                                  needReLogin: needReLogin)
                    .bind(to: sections)
                    .disposed(by: disposeBag)
                    return
                    
                case .failure(let error):
                    PrintDebugger.logError(error)
                    needReLogin.onNext(true)
                }
            }
        }
    }
}
