//
//  RecipeIngradient.swift
//  Gourmet
//
//  Created by 최승범 on 8/22/24.
//

import Foundation

struct RecipeIngredient: Hashable, Identifiable {
    let id = UUID()
    var type: IngredientType
    var name: String
    var value: String
    
    init(type: IngredientType,
         name: String,
         value: String) {
        self.type = type
        self.name = name
        self.value = value
    }
}
