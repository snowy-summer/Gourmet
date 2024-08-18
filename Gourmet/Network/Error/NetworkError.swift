//
//  NetworkError.swift
//  Gourmet
//
//  Created by 최승범 on 8/16/24.
//

import Foundation

enum NetworkError: Error, CustomStringConvertible {
    
    case invalidURL
    
    var description: String {
        switch self {
        case .invalidURL:
            return "잘못된 URL입니다."
        }
    }
}

enum EmailCheckError: Int, Error, CustomStringConvertible {
    
    case needRequiredValue = 400
    case inValidEmail = 409
    case inValidSesacKey = 420
    case tooManyRequest = 429
    case inValidURL = 444
    case serverError = 500
    
    var description: String {
        switch self {
        case .needRequiredValue:
            return "필수값을 채워주세요."
            
        case .inValidEmail:
            return "사용 불가능한 이메일입니다."
            
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
