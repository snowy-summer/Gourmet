//
//  UploadPostBodyModel.swift
//  Gourmet
//
//  Created by 최승범 on 8/16/24.
//

import Foundation

struct UploadPostBodyModel: Encodable {
    let title: String?
    let content: String?
    let subTitle: String?
    let ingredients: String?
    let recipe: String?
    let time: String?
    let difficulty: String?
    let productID: String?
    let price: Int = 100
    let files: [String]
    
    enum CodingKeys: String, CodingKey {
        case title
        case content
        case subTitle = "content1"
        case ingredients = "content2"
        case recipe = "content3"
        case time = "content4"
        case difficulty = "content5"
        case productID = "product_id"
        case price
        case files
    }
}
