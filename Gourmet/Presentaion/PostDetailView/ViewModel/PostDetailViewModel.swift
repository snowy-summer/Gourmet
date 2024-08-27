//
//  PostDetailViewModel.swift
//  Gourmet
//
//  Created by 최승범 on 8/26/24.
//

import Foundation
import RxSwift
import RxCocoa

final class PostDetailViewModel: ViewModelProtocol {
    
    enum Input {
        case noValue
        case viewDidLoad
    }
    
    enum Output {
        case noValue
        case reloadCollectionView([PostDTO])
    }
    
    private(set)var output = BehaviorSubject(value: Output.noValue)
    private let recipe: PostDTO
    private let disposeBag = DisposeBag()
    
    init(recipe: PostDTO) {
        self.recipe = recipe
        
    }
    
    func apply(_ input: Input) {
        
        switch input {
        case .noValue:
            return
            
        case .viewDidLoad:
            output.onNext(.reloadCollectionView([recipe]))

        }
    }
    
    func transform(_ input: Input) -> Output {
       
        return Output.noValue
    }
    
}

