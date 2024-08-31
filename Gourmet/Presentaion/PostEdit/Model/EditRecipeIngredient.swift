//
//  EditRecipeIngredient.swift
//  Gourmet
//
//  Created by 최승범 on 8/29/24.
//

import Foundation

struct EditRecipeIngredient: Hashable, Identifiable {
    let id = UUID()
    let type: IngredientType
    var isSelected = false
}
