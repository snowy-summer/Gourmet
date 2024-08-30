//
//  EditCategoryViewModel.swift
//  Gourmet
//
//  Created by 최승범 on 8/29/24.
//

import Foundation
import RxSwift
import RxCocoa

final class EditCategoryViewModel: ViewModelProtocol {
    
    enum Input {
        case noValue
        case selectedCategory(Int)
    }
    
    enum Output {
        case noValue
        case updateSnapshot
    }
    
    private(set) var category = FoodCategory.allCases.map { EditRecipeFoodCategory(category: $0) }
    private(set) var output = BehaviorSubject(value: Output.noValue)
    private let disposeBag = DisposeBag()
    
    init() {
        category[0].isSelected = true
    }
    
    func apply(_ input: Input) {
        
        switch input {
        case .noValue:
            return
            
        case .selectedCategory(let index):
            
            for i in 0..<FoodCategory.allCases.count {
                if i != index {
                    category[i].isSelected = false
                } else {
                    category[i].isSelected = true
                }
            }
            output.onNext(.updateSnapshot)
            
        }
    }
    
    func transform(_ input: Input) -> Output {
        return Output.noValue
    }
}
