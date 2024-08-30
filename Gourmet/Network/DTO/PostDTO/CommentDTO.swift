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
    let createAt: String
    let creator: UserDTO
    
    enum CodingKeys: String, CodingKey {
        case commentId = "comment_id"
        case content, createAt, creator
    }
}

