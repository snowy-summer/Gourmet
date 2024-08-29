//
//  FoodCategory.swift
//  Gourmet
//
//  Created by 최승범 on 8/20/24.
//

import Foundation

enum FoodCategory: CaseIterable {
    
    case main
    case dessert
    case appetizer
    case drink
    
    case korean
    case japanese
    case chinese
    case mexican
    case french
    case italian
    case indian
    case thai
    case american
    
    case pork
    case beef
    case fish
    case shellfish
    case mollusks
    case mushroom
    case bread
    case vegetarian
    case instant
    
    case normal
    
    var productId: String {
        switch self {
        case .korean:
            return "Gourmet_Korean"
        case .japanese:
            return "Gourmet_Japanese"
        case .chinese:
            return "Gourmet_Chinese"
        case .mexican:
            return "Gourmet_Mexican"
        case .french:
            return "Gourmet_French"
        case .italian:
            return "Gourmet_Italian"
        case .indian:
            return "Gourmet_Indian"
        case .thai:
            return "Gourmet_Thai"
        case .american:
            return "Gourmet_American"
            
        case .pork:
            return "Gourmet_Pork"
        case .beef:
            return "Gourmet_Beef"
        case .fish:
            return "Gourmet_Fish"
        case .shellfish:
            return "Gourmet_Shellfish"
        case .mollusks:
            return "Gourmet_Mollusks"
        case .mushroom:
            return "Gourmet_Mushroom"
        case .bread:
            return "Gourmet_Bread"
        case .vegetarian:
            return "Gourmet_Vegetarian"
        case .instant:
            return "Gourmet_Instant"
            
        case .appetizer:
            return "Gourmet_Appetizer"
        case .main:
            return "Gourmet_Main"
        case .dessert:
            return "Gourmet_Dessert"
        case .drink:
            return "Gourmet_Drink"
            
        case .normal:
            return "Gourmet_Normal"
        }
    }
    
    var name: String {
        switch self {
        case .korean:
            return "Korean"
        case .japanese:
            return "Japanese"
        case .chinese:
            return "Chinese"
        case .mexican:
            return "Mexican"
        case .french:
            return "French"
        case .italian:
            return "Italian"
        case .indian:
            return "Indian"
        case .thai:
            return "Thai"
        case .american:
            return "American"
        case .pork:
            return "Pork"
        case .beef:
            return "Beef"
        case .fish:
            return "Fish"
        case .shellfish:
            return "Shellfish"
        case .mollusks:
            return "Mollusks"
        case .mushroom:
            return "Mushroom"
        case .bread:
            return "Bread"
        case .vegetarian:
            return "Vegetarian"
        case .instant:
            return "Instant"
        case .main:
            return "Main Course"
        case .dessert:
            return "Dessert"
        case .appetizer:
            return "Appetizer"
        case .drink:
            return "Drink"
        case .normal:
            return "Normal"
        }
    }
    
    var iconName: String {
        switch self {
        default:
            return "testBird"
        }
    }
}
