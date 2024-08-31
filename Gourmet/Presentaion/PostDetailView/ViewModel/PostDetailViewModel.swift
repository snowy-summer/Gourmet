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
        case needReLogin
    }
    
    enum Item: Hashable {
        case imageTitle(PostDTO)
        case ingredient(RecipeIngredient)
        case recipeContent(RecipeContent)
    }
    
    private(set)var output = BehaviorSubject(value: Output.noValue)
    let recipe: PostDTO
    private(set) var ingredients = [Item]()
    private(set) var recipeStep = [Item]()
    
    private let networkManager: NetworkManagerProtocol
    private let disposeBag = DisposeBag()
    
    init(recipe: PostDTO,
         networkManger: NetworkManagerProtocol) {
        self.recipe = recipe
        self.networkManager = networkManger
        saveIngredients()
    }
    
    func apply(_ input: Input) {
        
        switch input {
        case .noValue:
            return
            
        case .viewDidLoad:
            saveRecipeStep()
            
        case .deletePost:
            deletePost()
            
        }
    }
    
    func transform(_ input: Input) -> Output {
        
        return Output.noValue
    }
    
    private func saveIngredients() {
        
        guard let content = recipe.ingredients else { return }
        let lines = content.split(separator: "\n")
        
        for line in lines {
            let components = line.split(separator: "@").map { String($0) }
            if components.count >= 2 {
                guard let index = Int(components[0]),
                      let type = IngredientType(rawValue: index) else { return }
                let name = components[1]
                let quantity = components[2]
                
                ingredients.append(.ingredient(RecipeIngredient(type: type,
                                                                name: name,
                                                                value: quantity)))
            }
        }
    }
    
    private func saveRecipeStep() {
        guard let content = recipe.recipe else { return }
        let lines = content.split(separator: "\n").map { String($0) }
        
        let dispatchGroup = DispatchGroup()
        
        for line in lines {
            let components = line.split(separator: ".").map { String($0) }
            if components.count >= 2 {
                let index = components[0]
                let text = components[1]
                
                if recipe.files.isEmpty {
                    recipeStep.append(.recipeContent(RecipeContent(thumbnailImage: nil,
                                                                   content: text)))
                } else {
                    
                    var addedContent = false
                    for filePath in recipe.files {
                        
                        if let range = filePath.range(of: #"(\d+)(?=_)"#,
                                                      options: .regularExpression) {
                            let numberBeforeUnderscore = filePath[range]
                            
                            if index == numberBeforeUnderscore {
                                dispatchGroup.enter()
                                addedContent = true
                                NetworkManager.shared.fetchImage(file: filePath) { [weak self] result in
                                    
                                    switch result {
                                    case .success(let data):
                                        if let data = data {
                                            self?.recipeStep.append(.recipeContent(RecipeContent(thumbnailImage: UIImage(data: data),
                                                                                                 content: text)))
                                        }
                                        dispatchGroup.leave()
                                        
                                    case .failure(let failure):
                                        self?.refreshAccessToken()
                                        dispatchGroup.leave()
                                    }
                                    
                                }
                            }
                        }
                    }
                    
                    if !addedContent {
                        recipeStep.append(.recipeContent(RecipeContent(thumbnailImage: nil,
                                                                       content: text)))
                    }
                    
                }
            }
        }
        
        dispatchGroup.notify(queue: .main) { [weak self] in
            guard let self = self else { return }
            output.onNext(.reloadCollectionView(recipe))
        }
    }
    
    private func deletePost() {
        
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
    
    private func refreshAccessToken() {
        
        networkManager.refreshAccessToken {[weak self] result in
            guard let self = self else { return }
            switch result {
            case .success:
                saveRecipeStep()
                
            case .failure(let error):
                PrintDebugger.logError(error)
                output.onNext(.needReLogin)
            }
        }
    }
}

