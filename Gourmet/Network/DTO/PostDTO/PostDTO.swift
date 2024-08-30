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
    let subTitle: String?
    let ingredients: String?
    let recipe: String?
    let time: String?
    let difficulty: String?
    let createdAt: String
    let creator: CreatorDTO
    let files: [String]
    let likes: [String]
    let likes2: [String]
    let hashTags: [String]
    let comments: [CommentDTO]
    
    enum CodingKeys: String, CodingKey {
        case postId = "post_id"
        case productID = "product_id"
        case title
        case content
        case subTitle = "content1"
        case ingredients = "content2"
        case recipe = "content3"
        case time = "content4"
        case difficulty = "content5"
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
