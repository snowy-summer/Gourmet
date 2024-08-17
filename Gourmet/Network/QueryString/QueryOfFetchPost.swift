//
//  QueryOfFetchPost.swift
//  Gourmet
//
//  Created by 최승범 on 8/16/24.
//

import Foundation

struct QueryOfFetchPost: QueryStringProtocol {
    
    private let next: String?
    private let limit: Int?
    private let productId: String?
    
    init(next: String? = nil,
         limit: Int? = nil,
         productId: String? = nil) {
        
        self.next = next
        self.limit = limit
        self.productId = productId
    }
    
    func queryItem() -> [URLQueryItem] {
        
        var queryItems = [URLQueryItem]()
        
        if let next = next {
            queryItems.append(URLQueryItem(name: "next",
                                           value: next))
        }
        
        if let limit = limit {
            queryItems.append(URLQueryItem(name: "limit",
                                           value: String(limit)))
        }
        
        if let productId = productId {
            queryItems.append(URLQueryItem(name: "product_id",
                                           value: productId))
        }
        
        return queryItems
        
    }
}
