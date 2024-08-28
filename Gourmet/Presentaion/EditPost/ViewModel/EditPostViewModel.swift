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
        case noValue
        case updateTitle(String)
        case addIngredient(IngredientContent)
        case addContent(RecipeContent)
        case updateTime(String)
        case saveContet
    }
    
    enum Output {
        case noValue
        case applySnapShot
    }
    
    enum Item: Hashable {
        case title(String?)
        case ingredient(String)
        case ingredientContent(IngredientContent?)
        case content(RecipeContent?)
        case neededTime(String)
        case difficulty(String)
        case price(Int)
    }
    
    private let networkManager: NetworkManagerProtocol
    private let disposeBag = DisposeBag()
    
    private(set)var output = BehaviorSubject(value: Output.noValue)
    
    private let category = FoodCategory.main
    private(set) var title = ""
    private(set) var subTitle = "부제"
    private(set) var ingredients = [IngredientContent]()
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
            
        case .updateTitle(let text):
            title = text
            
        case .addIngredient(let recipeIngredient):
            
            if let index = ingredients.firstIndex(where: { $0.id == recipeIngredient.id }) {
                ingredients[index] = recipeIngredient
            } else {
                ingredients.append(recipeIngredient)
            }
            
            output.onNext(.applySnapShot)
            
        case .addContent(let recipeContent):
            
            let addCell = contents.removeLast()
            
            if let index = contents.firstIndex(where: { $0.id == recipeContent.id }) {
                contents[index] = recipeContent
            } else {
                contents.append(recipeContent)
            }
            
            contents.append(addCell)
            output.onNext(.applySnapShot)
            
        case .updateTime(let time):
            return
            
        case .saveContet:
            uploadPost()
        }
        
    }
    
    func transform(_ input: Input) -> Output {
        
        return .noValue
    }
    
    private func uploadPost() {
        
        var datas = [Data?]()
        for i in contents {
            let data = i.thumbnailImage?.jpegData(compressionQuality: 1.0)
            datas.append(data)
        }
        
        networkManager.uploadImage(datas) { [weak self] result in
            guard let self = self else { return }
            
            switch result {
            case .success(let success):
            
                networkManager.uploadPost(item: createUploadPostBody(files: success.files))
                    .subscribe { result in
            
                    }
                    .disposed(by: disposeBag)
                
            case .failure(let failure):
                print(failure)
            }
        }
        
    }
    
    private func createUploadPostBody(files: [String]) -> UploadPostBodyModel {
        let ingredientStr = ingredients.enumerated().map { "\($0.element.name) \($0.element.value)" }
            .joined(separator: "\n")
        
        let recipeContent = contents.enumerated().map { "\($0.offset).\($0.element.content)" }
            .joined(separator: "\n")
        
        return UploadPostBodyModel(title: title,
                                   content: "#\(title)",
                                   subTitle: subTitle,
                                   ingredients: ingredientStr,
                                   recipe: recipeContent,
                                   time: time,
                                   difficulty: nil,
                                   productID: category.productId,
                                   files: files)
    }
    
    func generateItems(from item: Item) -> [Item] {
        switch item {
        case .title:
            return [
                .title(title),
//                .title(subTitle)
            ]
            
        case .ingredientContent:
            if ingredients.isEmpty {
               return []
            }
            
            return ingredients.map { .ingredientContent($0) }
            
        case .content:
            
            
            if contents.isEmpty {
                contents.append(RecipeContent(thumbnailImage: nil,
                                              content: "",
                                              isAddCell: true))
            }
            
            return contents.map { .content($0) }
            
        case .neededTime:
            return [.neededTime(time)]
            
        case .difficulty:
            return []
            
        case .price:
            return []
            
        default:
            return []
        }
    }
}
