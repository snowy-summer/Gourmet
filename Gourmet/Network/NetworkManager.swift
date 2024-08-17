//
//  NetworkManager.swift
//  Gourmet
//
//  Created by 최승범 on 8/16/24.
//

import Foundation
import Alamofire

struct NetworkManager {
    
    private let session: Session
    
    init(session: Session = .default) {
        self.session = session
    }
    
    func fetchData<T: Decodable>(_ object: T.Type,
                                 router: URLRequestConvertible,
                                 completionHandler: @escaping (Result<T,Error>) -> Void){
        
        session.request(router)
            .validate(statusCode: 200..<300)
            .responseDecodable(of: T.self) { response in
                switch response.result {
                case .success(let data):
                    completionHandler(.success(data))
                case .failure(let error):
                    completionHandler(.failure(error))
                }
            }
    }

}

