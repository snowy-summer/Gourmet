//
//  SignUpDTO.swift
//  Gourmet
//
//  Created by 최승범 on 8/16/24.
//

import Foundation

struct SignUpDTO: Decodable {
    let userId: String
    let email: String
    let nick: String
    let phoneNum: String?
    let birthDay: String?
    
    enum CodingKeys: String, CodingKey {
        case userId = "user_id"
        case email, nick
        case phoneNum, birthDay
    }
}
