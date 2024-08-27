//
//  Category.swift
//  Gourmet
//
//  Created by 최승범 on 8/26/24.
//

import Foundation

struct Category: Hashable {
    let id: FoodCategory
    var isSelected = false
    var nextCursor = ""
}
