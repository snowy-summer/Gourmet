//
//  LoginDTO.swift
//  Gourmet
//
//  Created by 최승범 on 8/16/24.
//

import Foundation

struct LoginDTO: Decodable {
    let userId: String
    let email: String
    let nick: String
    let accessToken: String
    let refreshToken: String
    let profileImage: String?
    
    enum CodingKeys: String, CodingKey {
        case userId = "user_id"
        case email, nick
        case accessToken, refreshToken
        case profileImage
    }
}
