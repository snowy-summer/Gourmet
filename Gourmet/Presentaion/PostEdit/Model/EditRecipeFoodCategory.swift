//
//  EditRecipeFoodCategory.swift
//  Gourmet
//
//  Created by 최승범 on 8/29/24.
//

import Foundation

struct EditRecipeFoodCategory: Hashable, Identifiable {
    let id = UUID()
    let category: FoodCategory
    var isSelected = false
}

