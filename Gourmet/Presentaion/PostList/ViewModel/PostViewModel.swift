//
//  PostViewModel.swift
//  Gourmet
//
//  Created by 최승범 on 8/25/24.
//

import Foundation
import RxSwift
import RxCocoa

final class PostViewModel: ViewModelProtocol {
    
    enum Input {
        case noValue
        case viewDidLoad
        case selectCategory(Int)
        case selectRecipe(Int)
    }
    
    enum Output {
        case noValue
        case reloadCollectionView(categorys: [Category], recipeList: [PostDTO])
        case needLogin
        case showDetailView(PostDTO)
    }
    
    private let networkManager: NetworkManagerProtocol
    
    var categorys = [Category]()
    var category = Category(id: .main)
    
    private(set)var output = BehaviorSubject(value: Output.noValue)
    private var recipeList = PostListDTO(data: [], nextCursor: "")
    private let disposeBag = DisposeBag()
    
    init(networkManager: NetworkManagerProtocol) {
        self.networkManager = networkManager
        
        for category in FoodCategory.allCases {
            let category = Category(id: category)
            categorys.append(category)
        }
        categorys.removeLast()
        categorys[0].isSelected = true
        
    }
    
    func apply(_ input: Input) {
        
        switch input {
        case .noValue:
            return
            
        case .viewDidLoad:
            fetchPost()
            
        case .selectCategory(let item):
            if category != categorys[item] {
                category = categorys[item]
                
                for index in 0..<categorys.count {
                    categorys[index].isSelected = (categorys[index].id == category.id)
                }
            }
            
            fetchPost()
    
        case .selectRecipe(let item):
            output.onNext(.showDetailView(recipeList.data[item]))

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
                    owner.recipeList = data
                    owner.category.nextCursor = data.nextCursor
                    owner.output.onNext(.reloadCollectionView(categorys: owner.categorys,
                                                              recipeList: owner.recipeList.data))
                    
                case .failure(let error):
                    if error == .expiredAccessToken {
                        
                        let isSuccess = owner.networkManager.refreshAccessToken()
                        owner.refreshToken(isSuccess: isSuccess)
                        
                    } else {
                        print(error)
                        owner.output.onNext(.needLogin)
                    }
                    
                }
            }
            .disposed(by: disposeBag)
    }
    
    private func refreshToken(isSuccess: Single<Bool>) {
        
        isSuccess.subscribe(with: self) { owner, value in
            if value {
                owner.networkManager.fetchPost(category: owner.category)
                    .subscribe(with: self) { owner, result in
                        
                        switch result {
                        case .success(let data):
                            owner.category.nextCursor = data.nextCursor
                            owner.recipeList = data
                            owner.output.onNext(.reloadCollectionView(categorys: owner.categorys,
                                                                      recipeList: owner.recipeList.data))
                        case .failure:
                            owner.output.onNext(.needLogin)
                        }
                    }.disposed(by: owner.disposeBag)
                
            } else {
                owner.output.onNext(.needLogin)
            }
        }.disposed(by: disposeBag)
    }
}
