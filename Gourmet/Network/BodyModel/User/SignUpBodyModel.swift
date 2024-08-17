//
//  SignUpBodyModel.swift
//  Gourmet
//
//  Created by 최승범 on 8/16/24.
//

import Foundation

struct SignUpBodyModel: Encodable {
    let email: String
    let password: String
    let nick: String
    let phoneNum: String?
    let birthDay: String?
}
