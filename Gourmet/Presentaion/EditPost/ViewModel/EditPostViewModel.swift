//
//  EditPostViewModel.swift
//  Gourmet
//
//  Created by 최승범 on 8/22/24.
//

import Foundation
import RxSwift
import RxCocoa

final class EditPostViewModel: ViewModelProtocol {
    
    struct Input {
        let saveButtonTap: ControlEvent<Void>
    }
    
    struct Output { }
    
    enum Item: Hashable {
        case title(String?)
        case ingredient(RecipeIngredient?)
        case content(RecipeContent?)
        case neededTime(String)
        case price(Int)
    }
    
    private let networkManager: NetworkManagerProtocol
    private let disposeBag = DisposeBag()
    
    private let category = FoodCategory.main
    private(set) var title = ""
    private(set) var ingredients = [RecipeIngredient]()
    private(set) var contents = [RecipeContent]()
    private(set) var time = ""
    private(set) var price = 0
    
    init(networkManager: NetworkManagerProtocol) {
        self.networkManager = networkManager
    }
    
    func transform(_ input: Input) -> Output {
        input.saveButtonTap
            .bind(with: self) { owner, _ in
                owner.uploadPost()
            }
            .disposed(by: disposeBag)
        
        return Output()
    }
    
    private func uploadPost() {
        networkManager.uploadPost(item: createUploadPostBody())
            .subscribe { result in
                
            }
            .disposed(by: disposeBag)
    }
    
    private func createUploadPostBody() -> UploadPostBodyModel {
        let ingredientStr = ingredients.enumerated().map { "\($0.offset).\($0.element.name) \($0.element.value)" }
            .joined(separator: "\n")
        
        let recipeContent = contents.enumerated().map { "\($0.offset).\($0.element.contet)" }
            .joined(separator: "\n")
        
        return UploadPostBodyModel(title: title,
                                   content: ingredientStr,
                                   content1: recipeContent,
                                   content2: time,
                                   content3: nil,
                                   content4: nil,
                                   content5: nil,
                                   productID: category.productId,
                                   files: []
        )
    }
    
    func generateItems(from item: Item) -> [Item] {
        switch item {
        case .title:
            return [.title(title)]
            
        case .ingredient:
            return ingredients.map { .ingredient($0) } + [.ingredient(RecipeIngredient(name: "",
                                                                                       value: "",
                                                                                       isAddCell: true))]
            
        case .content:
            return contents.map { .content($0) } + [.content(RecipeContent(thumbnailImage: nil,
                                                                           contet: "",
                                                                           isAddCell: true))]
            
        case .neededTime:
            return [.neededTime(time)]
            
        case .price:
            return []
        }
    }
}
