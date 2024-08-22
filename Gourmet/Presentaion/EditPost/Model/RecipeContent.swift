//
//  RecipeContent.swift
//  Gourmet
//
//  Created by 최승범 on 8/22/24.
//

import UIKit

struct RecipeContent: Hashable {
    let id = UUID()
    let thumbnailImage: UIImage?
    let contet: String
    let isAddCell: Bool
    
    init(thumbnailImage: UIImage?,
         contet: String,
         isAddCell: Bool = false) {
        self.thumbnailImage = thumbnailImage
        self.contet = contet
        self.isAddCell = isAddCell
    }
}
