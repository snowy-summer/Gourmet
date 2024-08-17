//
//  EditProfileBodyModel.swift
//  Gourmet
//
//  Created by 최승범 on 8/16/24.
//

import Foundation

struct EditProfileBodyModel: Encodable {
    let nick: String?
    let phoneNum: String?
    let birthDay: String?
    let profile: Data?
}
