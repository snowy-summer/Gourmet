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
    private var koNextCursor = ""
    private var jaNextCursor = ""
    private let sections = PublishSubject<[HomeViewSectionModel]>()
    private let disposeBag = DisposeBag()
    
    init(networkManager: NetworkManagerProtocol) {
        self.networkManager = networkManager
    }
    
    func transform(_ input: Input) -> Output {
        let needReLogin = PublishSubject<Bool>()
        
        fetchSections(signal: input.reload,
                      needReLogin: needReLogin)
            .bind(to: sections)
            .disposed(by: disposeBag)
        
        return Output(sections: sections.asObservable(),
                      needReLogin: needReLogin)
    }
    
    private func fetchSections(signal: Observable<Void>,
                               needReLogin: PublishSubject<Bool>) -> Observable<[HomeViewSectionModel]> {
        
        let koFoodRequest = createPostRequest(signal: signal, category: "Gourmet_KoreanFood")
        let jaFoodRequest = createPostRequest(signal: signal, category: "Gourmet_JapaneseFood")
        
        return Observable.zip(koFoodRequest, jaFoodRequest)
            .map { [weak self] koResult, jaResult in
                guard let self = self else { return [] }
                
                var sections = [HomeViewSectionModel]()
                
                handleResult(result: koResult, category: "한식", nextCursor: &self.koNextCursor, sections: &sections, needReLogin: needReLogin)
                handleResult(result: jaResult, category: "일식", nextCursor: &self.jaNextCursor, sections: &sections, needReLogin: needReLogin)
                
                return sections
            }
    }
    
    private func createPostRequest(signal: Observable<Void>,
                                   category: String) -> Observable<Result<PostListDTO, PostError>> {
        return signal
            .flatMapLatest { [weak self] _ -> Single<Result<PostListDTO, PostError>> in
                guard let self = self else { return .just(.failure(.forbidden)) }
                let nextCursor = category == "Gourmet_KoreanFood" ? koNextCursor : jaNextCursor
                return self.networkManager.fetchPost(next: nextCursor,
                                                     category: category)
            }
            .asObservable()
    }
    
    private func handleResult(result: Result<PostListDTO, PostError>,
                              category: String,
                              nextCursor: inout String,
                              sections: inout [HomeViewSectionModel],
                              needReLogin: PublishSubject<Bool>) {
        
        switch result {
        case .success(let data):
            let section = HomeViewSectionModel(header: category, items: data.data)
            sections.append(section)
            nextCursor = data.nextCursor
            
        case .failure(let error):
            print(error)
            handleFailure(error: error, needReLogin: needReLogin)
        }
    }
    
    private func handleFailure(error: PostError,
                               needReLogin: PublishSubject<Bool>) {
        if error == .expiredAccessToken {
            networkManager.refreshAccessToken()
                .subscribe(with: self) { owner, success in
                    if success {
                        owner.fetchSections(signal: Observable.just(()), needReLogin: needReLogin)
                            .bind(to: owner.sections)
                            .disposed(by: owner.disposeBag)
                    } else {
                        needReLogin.onNext(true)
                    }
                }
                .disposed(by: disposeBag)
        } else {
            needReLogin.onNext(true)
        }
    }
}
