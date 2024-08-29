//
//  IngredientViewModel.swift
//  Gourmet
//
//  Created by 최승범 on 8/28/24.
//

import Foundation
import RxSwift
import RxCocoa

final class IngredientViewModel: ViewModelProtocol {
    
    enum Input {
        case noValue
        case selectIngredientType(Int)
    }
    
    enum Output {
        case noValue
        case reloadView
    }
    
    private(set)var output = BehaviorSubject(value: Output.noValue)
    private(set) var ingredients = IngredientType.allCases.map {
        EditRecipeIngredient(type: $0 )
    }
    private(set) var selectIngredientType = IngredientType.beef
    private let disposeBag = DisposeBag()
    
    init() {
        ingredients[0].isSelected = true
    }
    
    func apply(_ input: Input) {
        
        switch input {
        case .noValue:
            return
            
        case .selectIngredientType(let index):
            if let type = IngredientType(rawValue: index) {
                selectIngredientType = type
            }
            
            for i in 0..<IngredientType.allCases.count {
                if i != index {
                    ingredients[i].isSelected = false
                } else {
                    ingredients[i].isSelected = true
                }
            }
        
            output.onNext(.reloadView)
        }
    }
    
    func transform(_ input: Input) -> Output {
        return Output.noValue
    }
}
