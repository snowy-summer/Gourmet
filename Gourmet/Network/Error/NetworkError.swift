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
