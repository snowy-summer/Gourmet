//
//  PostDetailViewModel.swift
//  Gourmet
//
//  Created by 최승범 on 8/26/24.
//

import UIKit
import RxSwift
import RxCocoa

final class PostDetailViewModel: ViewModelProtocol {
    
    enum Input {
        case noValue
        case viewDidLoad
        case deletePost
    }
    
    enum Output {
        case noValue
        case reloadCollectionView(PostDTO)
        case deleteSuccess
        case deleteFail(PostError)
    }
    
    enum Item: Hashable {
        case imageTitle(PostDTO)
        case ingredient(RecipeIngredient)
        case recipeContent(RecipeContent)
    }
    
    private(set)var output = BehaviorSubject(value: Output.noValue)
    private let recipe: PostDTO
    private(set) var ingredients = [Item]()
    private(set) var recipeStep = [Item]()
    
    private let networkManager: NetworkManagerProtocol
    private let disposeBag = DisposeBag()
    
    init(recipe: PostDTO,
         networkManger: NetworkManagerProtocol) {
        self.recipe = recipe
        self.networkManager = networkManger
        saveIngredients()
        saveRecipeStep()
    }
    
    func apply(_ input: Input) {
        
        switch input {
        case .noValue:
            return
            
        case .viewDidLoad:
            output.onNext(.reloadCollectionView(recipe))
            
        case .deletePost:
            deletePost()
            
        }
    }
    
    func transform(_ input: Input) -> Output {
       
        return Output.noValue
    }
    
    func saveIngredients() {
        
        guard let content = recipe.ingredients else { return }
        let lines = content.split(separator: "\n")

        for line in lines {
            let components = line.split(separator: "@").map { String($0) }
            if components.count >= 2 {
                guard let index = Int(components[0]),
                      let type = IngredientType(rawValue: index) else { return }
                let name = components[1]
                let quantity = components[1]
                
                ingredients.append(.ingredient(RecipeIngredient(type: type,
                                                                name: name,
                                                                value: quantity)))
            }
        }
    }
    
    func saveRecipeStep() {
        
        guard let content = recipe.recipe else { return }
        let lines = content.split(separator: "\n")

        for line in lines {
            let components = line.split(separator: ".").map { String($0) }
            if components.count >= 2 {
                if let index = Int(components[0]){
                    let text = components[1]
                    if recipe.files.isEmpty {
                        ingredients.append(.recipeContent(RecipeContent(thumbnailImage: nil, content: text)))
                    } else {
                        
                        NetworkManager.shared.fetchImage(file: recipe.files[0]) { [weak self] data in
                            if let data = data {
                                self?.ingredients.append(.recipeContent(RecipeContent(thumbnailImage: UIImage(data: data),
                                                                                      content: text)))
                            }
                        }
                    }
                }
                
                
                
            }
        }
    }
    
    func deletePost() {
        
        networkManager.deletePost(id: recipe.postId) { [weak self] result in
            guard let self = self else { return }
            
            switch result {
            case .success:
                output.onNext(.deleteSuccess)
                
            case .failure(let error):
                output.onNext(.deleteFail(error))
            }
        }

    }
}

