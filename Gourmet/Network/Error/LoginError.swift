//
//  LoginError.swift
//  Gourmet
//
//  Created by 최승범 on 8/19/24.
//

import Foundation

enum LoginError: Int, Error, CustomStringConvertible {
    
    case needRequiredValue = 400
    case already = 409
    case inValidSesacKey = 420
    case tooManyRequest = 429
    case inValidURL = 444
    case serverError = 500
    
    var description: String {
        switch self {
        case .needRequiredValue:
            return "필수값을 채워주세요."
            
        case .already:
            return "이미 존재하는 유저입니다"
            
        case .inValidSesacKey:
            return "잘못된 키입니다"
            
        case .tooManyRequest:
            return "과호출입니다"
            
        case .inValidURL:
            return "잘못된 URL입니다."
            
        case .serverError:
            return "서버에서 에러가 발생했습니다."
        }
    }
}
