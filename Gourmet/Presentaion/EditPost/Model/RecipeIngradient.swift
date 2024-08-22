//
//  RecipeIngradient.swift
//  Gourmet
//
//  Created by 최승범 on 8/22/24.
//

import Foundation

struct RecipeIngredient: Hashable {
    let id = UUID()
    let name: String
    let value: String
}
