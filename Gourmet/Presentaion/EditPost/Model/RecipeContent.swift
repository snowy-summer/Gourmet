//
//  RecipeContent.swift
//  Gourmet
//
//  Created by 최승범 on 8/22/24.
//

import UIKit

struct RecipeContent: Hashable, Identifiable {
    let id = UUID()
    var thumbnailImage: UIImage?
    var content: String
    
    init(thumbnailImage: UIImage?,
         content: String) {
        self.thumbnailImage = thumbnailImage
        self.content = content
    }
}
