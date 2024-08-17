//
//  PostListDTO.swift
//  Gourmet
//
//  Created by 최승범 on 8/16/24.
//

import Foundation

struct PostListDTO: Decodable {
    let data: [PostDTO]
    let nextCursor: String
    
    enum CodingKeys: String, CodingKey {
        case data
        case nextCursor = "next_cursor"
    }
}
