//
//  PaymentBodyModel.swift
//  Gourmet
//
//  Created by 최승범 on 8/31/24.
//

import Foundation

struct PaymentBodyModel: Encodable {
    let impUID: String
    let postId: String
    
    enum CodingKeys: String, CodingKey {
        case impUID = "imp_uid"
        case postId = "post_id"
    }
}
