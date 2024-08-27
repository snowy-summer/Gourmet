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
    }
    
    enum Output {
        case noValue
        case reloadCollectionView(PostDTO)
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
    private let disposeBag = DisposeBag()
    
    init(recipe: PostDTO) {
        self.recipe = recipe
        saveIngredients()
        saveRecipeStep()
    }
    
    func apply(_ input: Input) {
        
        switch input {
        case .noValue:
            return
            
        case .viewDidLoad:
            output.onNext(.reloadCollectionView(recipe))

        }
    }
    
    func transform(_ input: Input) -> Output {
       
        return Output.noValue
    }
    
    func saveIngredients() {
        
        guard let content = recipe.ingredients else { return }
        let lines = content.split(separator: "\n")

        for line in lines {
            let components = line.split(separator: " ").map { String($0) }
            if components.count >= 2 {
                let item = components[0]
                let quantity = components[1]
                
                ingredients.append(.ingredient(RecipeIngredient(name: item, value: quantity)))
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
}

