//
//  Routerable.swift
//  Gourmet
//
//  Created by 최승범 on 8/16/24.
//

import Foundation
import Alamofire

protocol RouterAble: URLRequestConvertible {
    var scheme: String { get }
    var host: String { get }
    var path: String { get }
    var port: Int? { get }
    var body: Data? { get }
    var query: [URLQueryItem] { get }
    var url: URL? { get }
    var headers: HTTPHeaders { get }
    var method: HTTPMethod { get }
}
