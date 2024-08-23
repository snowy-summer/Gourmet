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
    
    enum Input {
//        case saveButtonTap: ControlEvent<Void>
        case noValue
        case addIngredient(RecipeIngredient)
    }
    
    enum Output {
        case noValue
        case applySnapShot
    }
    
    enum Item: Hashable {
        case title(String?)
        case ingredient(RecipeIngredient?)
        case content(RecipeContent?)
        case neededTime(String)
        case price(Int)
    }
    
    private let networkManager: NetworkManagerProtocol
    private let disposeBag = DisposeBag()
    
    private(set)var output = BehaviorSubject(value: Output.noValue)
    
    private let category = FoodCategory.main
    private(set) var title = ""
    private(set) var ingredients = [RecipeIngredient]()
    private(set) var contents = [RecipeContent]()
    private(set) var time = ""
    private(set) var price = 0
    
    init(networkManager: NetworkManagerProtocol) {
        self.networkManager = networkManager
    }
    
    func apply(_ input: Input) {
        
        switch input {
        case .noValue:
            output.onNext(.noValue)
            
        case .addIngredient(let recipeIngredient):
            
            let addCell = ingredients.removeLast()
            
            if let index = ingredients.firstIndex(where: { $0.id == recipeIngredient.id }) {
                ingredients[index] = recipeIngredient
            } else {
                ingredients.append(recipeIngredient)
            }
            
            ingredients.append(addCell)
            
            output.onNext(.applySnapShot)
        }
        
    }
    
    func transform(_ input: Input) -> Output {
//        input.saveButtonTap
//            .bind(with: self) { owner, _ in
//                owner.uploadPost()
//            }
//            .disposed(by: disposeBag)
//        
        return .noValue
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
            
            if ingredients.isEmpty {
                ingredients.append(RecipeIngredient(name: "",
                                                    value: "",
                                                    isAddCell: true))
            }
            
            return ingredients.map { .ingredient($0) }
            
        case .content:
            
            
            if contents.isEmpty {
                contents.append(RecipeContent(thumbnailImage: nil,
                                              contet: "",
                                              isAddCell: true))
            }
            
            return contents.map { .content($0) }
            
        case .neededTime:
            return [.neededTime(time)]
            
        case .price:
            return []
        }
    }
}
