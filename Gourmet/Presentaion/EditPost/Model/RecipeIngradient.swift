//
//  RecipeIngradient.swift
//  Gourmet
//
//  Created by 최승범 on 8/22/24.
//

import Foundation

struct RecipeIngredient: Hashable {
    let id = UUID()
    var name: String
    var value: String
    let isAddCell: Bool
    
    init(name: String,
         value: String,
         isAddCell: Bool = false) {
        self.name = name
        self.value = value
        self.isAddCell = isAddCell
    }
}
