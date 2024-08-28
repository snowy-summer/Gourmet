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
        case reloadView([PostDTO])
        case needReLogin
    }
    
    private(set)var output = BehaviorSubject(value: Output.noValue)
    private let ingredientType = IngredientType.allCases
    private(set) var selectIngredientType = IngredientType.beef
    private let disposeBag = DisposeBag()
    
    func apply(_ input: Input) {
        
        switch input {
        case .noValue:
            return
            
        case .selectIngredientType(let item):
            if let type = IngredientType(rawValue: item) {
                selectIngredientType = type
            }
        
        }
    }
    
    func transform(_ input: Input) -> Output {
        return Output.noValue
    }
}

enum IngredientType: Int, CaseIterable {
    case beef       // 소고기
    case chicken    // 닭고기
    case pork       // 돼지고기
    case fish       // 생선
    case shrimp     // 새우
    case water      // 물
    case salt       // 소금
    case oil        // 오일 (예: 식용유)
    case onion      // 양파
    case garlic     // 마늘
    case tomato     // 토마토
    case potato     // 감자
    case carrot     // 당근
    case bellPepper // 파프리카
    case spinach    // 시금치
    case broccoli   // 브로콜리
    case mushroom   // 버섯
    case hub
    case lemon      // 레몬
    case butter     // 버터
    case cheese     // 치즈
    
    var imageName: String {
        switch self {
        case .beef:
            return "recipe"
        case .chicken:
            return "recipe"
        case .pork:
            return "recipe"
        case .fish:
            return "recipe"
        case .shrimp:
            return "recipe"
        case .water:
            return "recipe"
        case .salt:
            return "recipe"
        case .oil:
            return "recipe"
        case .onion:
            return "recipe"
        case .garlic:
            return "recipe"
        case .tomato:
            return "recipe"
        case .potato:
            return "recipe"
        case .carrot:
            return ""
        case .bellPepper:
            return ""
        case .spinach:
            return ""
        case .broccoli:
            return ""
        case .mushroom:
            return ""
        case .hub:
            return ""
        case .lemon:
            return ""
        case .butter:
            return ""
        case .cheese:
            return ""
        }
    }
}
