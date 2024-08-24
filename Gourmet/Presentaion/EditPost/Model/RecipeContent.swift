//
//  RecipeContent.swift
//  Gourmet
//
//  Created by 최승범 on 8/22/24.
//

import UIKit

struct RecipeContent: Hashable {
    let id = UUID()
    var thumbnailImage: UIImage?
    var content: String
    let isAddCell: Bool
    
    init(thumbnailImage: UIImage?,
         content: String,
         isAddCell: Bool = false) {
        self.thumbnailImage = thumbnailImage
        self.content = content
        self.isAddCell = isAddCell
    }
}
