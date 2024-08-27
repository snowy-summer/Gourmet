//
//  PostDTO.swift
//  Gourmet
//
//  Created by 최승범 on 8/16/24.
//

import Foundation

struct PostDTO: Decodable, Hashable {
    let postId: String
    let productID: String?
    let title: String?
    let content: String?
    let subTitle: String? // 서브 타이틀
    let ingredients: String? // 재료
    let recipe: String? // 레시피
    let content4: String?
    let content5: String?
    let createdAt: String
    let creator: CreatorDTO
    let files: [String]
    let likes: [String]
    let likes2: [String]
    let hashTags: [String]
    let comments: [ComentsDTO]
    
    enum CodingKeys: String, CodingKey {
        case postId = "post_id"
        case productID = "product_id"
        case title
        case content
        case subTitle = "content1"
        case ingredients = "content2"
        case recipe = "content3"
        case content4
        case content5
        case createdAt, creator
        case files, likes, hashTags, comments
        case likes2
    }
}

struct CreatorDTO: Decodable, Hashable {
    let userId: String
    let nick: String
    
    enum CodingKeys: String, CodingKey {
        case userId = "user_id"
        case nick
    }
}
