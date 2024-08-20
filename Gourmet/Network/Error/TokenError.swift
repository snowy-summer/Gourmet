//
//  TokenError.swift
//  Gourmet
//
//  Created by 최승범 on 8/19/24.
//

import Foundation

enum TokenError: Int, Error, CustomStringConvertible {
    
    case needRequiredValue = 400
    case invalidToken = 401
    case forbidden = 403
    case expiredRefreshToken = 418
    case inValidSesacKey = 420
    case tooManyRequest = 429
    case inValidURL = 444
    case serverError = 500
    
    var description: String {
        switch self {
        case .needRequiredValue:
            return "필수값을 채워주세요."
            
        case .invalidToken:
            return "인증이 불가능한 토큰입니다"
            
        case .forbidden:
            return "권한이 없습니다"
            
        case .expiredRefreshToken:
            return "리프레시 토큰이 만료되었습니다"
            
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
