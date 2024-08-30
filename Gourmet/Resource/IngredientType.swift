//
//  IngredientType.swift
//  Gourmet
//
//  Created by 최승범 on 8/29/24.
//

import Foundation

enum IngredientType: Int, CaseIterable {
    case crab
    case shellfish
    case beef       // 소고기
    case chicken    // 닭고기
    case fish       // 생선
    case shrimp     // 새우
    case salt       // 소금
    case oil        // 오일 (예: 식용유)
    case onion      // 양파
    case tomato     // 토마토
    case potato     // 감자
    case carrot     // 당근
    case bellPepper // 파프리카
    case mushroom   // 버섯
    case hub
    
    var imageName: String {
        switch self {
        case .crab:
            return "crab"
        case .shellfish:
            return "shellfish"
        case .beef:
            return "beef"
        case .chicken:
            return "chicken"
        case .fish:
            return "fish"
        case .shrimp:
            return "shrimp"
        case .salt:
            return "salt"
        case .oil:
            return "oil"
        case .onion:
            return "onion"
        case .tomato:
            return "tomato"
        case .potato:
            return "potato"
        case .carrot:
            return "carrot"
        case .bellPepper:
            return "bellPepper"
        case .mushroom:
            return "mushroom"
        case .hub:
            return "hub"
        }
    }
}
