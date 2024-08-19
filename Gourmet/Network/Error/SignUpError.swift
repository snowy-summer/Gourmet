//
//  SignUpError.swift
//  Gourmet
//
//  Created by 최승범 on 8/19/24.
//

import Foundation

enum SignUpError: Int, Error, CustomStringConvertible {
    
    case needRequiredValue = 400
    case checkYourInformation = 401
    case inValidSesacKey = 420
    case tooManyRequest = 429
    case inValidURL = 444
    case serverError = 500
    
    var description: String {
        switch self {
        case .needRequiredValue:
            return "필수값을 채워주세요."
            
        case .checkYourInformation:
            return "계정이나 비밀번호를 확인해주세요"
            
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
