//
//  PostDTO.swift
//  Gourmet
//
//  Created by 최승범 on 8/16/24.
//

import Foundation

struct PostDTO: Decodable {
    let postId: String
    let productID: String?
    let title: String?
    let content: String?
    let content1: String?
    let content2: String?
    let content3: String?
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
        case content1
        case content2
        case content3
        case content4
        case content5
        case createdAt, creator
        case files, likes, hashTags, comments
        case likes2
    }
}

struct CreatorDTO: Decodable {
    let userId: String
    let nick: String
    
    enum CodingKeys: String, CodingKey {
        case userId = "user_id"
        case nick
    }
}
