//
//  PostError.swift
//  Gourmet
//
//  Created by 최승범 on 8/19/24.
//

import Foundation

enum PostError: Int, Error, CaseIterable {
    
    case needRequiredValue = 400
    case invalidAccessToken = 401
    case forbidden = 403
    case cantFindPost = 410
    case expiredAccessToken = 419
    case inValidSesacKey = 420
    case tooManyRequest = 429
    case inValidURL = 444
    case cantAccessPost = 445
    case serverError = 500
    
    var description: String {
        switch self {
        case .needRequiredValue:
            return "필수값을 채워주세요."
            
        case .invalidAccessToken:
            return "유효하지 않은 엑세스 토큰입니다"
            
        case .forbidden:
            return "접근권한이 없습니다"
            
        case .cantFindPost:
            return "삭제된 게시글입니다"
            
        case .expiredAccessToken:
            return "액세스 토큰이 만료되었습니다"
            
        case .inValidSesacKey:
            return "잘못된 키입니다"
            
        case .tooManyRequest:
            return "과호출입니다"
            
        case .inValidURL:
            return "잘못된 URL입니다."
            
        case .cantAccessPost:
            return "게시글에 대한 권한이 없습니다"
            
        case .serverError:
            return "서버에서 에러가 발생했습니다."
        }
    }
}
