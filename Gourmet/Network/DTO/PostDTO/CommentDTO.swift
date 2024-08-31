//
//  CommentDTO.swift
//  Gourmet
//
//  Created by 최승범 on 8/16/24.
//

import Foundation

struct CommentDTO: Decodable, Hashable {
    let commentId: String
    let content: String
    let createdAt: String
    let creator: CreatorDTO
    
    enum CodingKeys: String, CodingKey {
        case commentId = "comment_id"
        case content, createdAt, creator
    }
}

