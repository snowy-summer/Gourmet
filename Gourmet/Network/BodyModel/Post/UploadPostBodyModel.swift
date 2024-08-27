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
    let subTitle: String? // 내용
    let ingredients: String? // 시간
    let recipe: String?
    let content4: String?
    let content5: String?
    let productID: String?
    let files: [String]
    
    enum CodingKeys: String, CodingKey {
        case title
        case content
        case subTitle = "content1"
        case ingredients = "content2"
        case recipe = "content3"
        case content4
        case content5
        case productID = "product_id"
        case files
    }
}
