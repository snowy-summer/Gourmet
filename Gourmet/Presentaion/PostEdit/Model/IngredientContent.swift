//
//  IngredientContent.swift
//  Gourmet
//
//  Created by 최승범 on 8/28/24.
//

import Foundation

struct IngredientContent: Hashable, Identifiable {
    let id = UUID()
    var type: IngredientType
    var name: String
    var value: String
}
