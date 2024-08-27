//
//  UserDTO.swift
//  Gourmet
//
//  Created by 최승범 on 8/16/24.
//

import Foundation

struct UserDTO: Decodable, Hashable {
    let userId: String
    let email: String
    let nick: String
    let profileImage: String?
    
    enum CodingKeys: String, CodingKey {
        case userId = "user_id"
        case email, nick
        case profileImage
    }
}
