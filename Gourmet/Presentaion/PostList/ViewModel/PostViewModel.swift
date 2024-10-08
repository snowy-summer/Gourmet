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
        case refreshData
        case updateNextData
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
    
    private(set) var output = BehaviorSubject(value: Output.noValue)
    private(set) var recipeList = PostListDTO(data: [], nextCursor: "")
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
            
        case .refreshData:
            fetchPost()
            
        case .updateNextData:
            fetchPost()
            
        case .selectCategory(let item):
            if category != categorys[item] {
                category = categorys[item]
                
                for index in 0..<categorys.count {
                    categorys[index].isSelected = (categorys[index].id == category.id)
                }
            }
            recipeList = PostListDTO(data: [], nextCursor: "")
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
                    if owner.recipeList.data.isEmpty {
                        owner.recipeList = data
                    } else if owner.category.nextCursor != "" {
                        return
                    } else {
                        owner.recipeList.data += data.data
                    }
                    owner.category.nextCursor = data.nextCursor
                    owner.output.onNext(.reloadCollectionView(categorys: owner.categorys,
                                                              recipeList: owner.recipeList.data))
                    
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
                output.onNext(.needLogin)
            }
        }
    }
}
