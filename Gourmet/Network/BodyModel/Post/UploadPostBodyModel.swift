//
//  UploadPostBodyModel.swift
//  Gourmet
//
//  Created by 최승범 on 8/16/24.
//

import Foundation

struct UploadPostBodyModel: Encodable {
    let title: String?
    let content: String? // 재료
    let content1: String? // 내용
    let content2: String? // 시간
    let content3: String?
    let content4: String?
    let content5: String?
    let productID: String?
    let files: [String]
    
    enum CodingKeys: String, CodingKey {
        case title
        case content
        case content1
        case content2
        case content3
        case content4
        case content5
        case productID = "product_id"
        case files
    }
}
