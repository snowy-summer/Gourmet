//
//  NetworkManagerProtocol.swift
//  Gourmet
//
//  Created by 최승범 on 8/20/24.
//

import Foundation
import Alamofire
import RxSwift

protocol NetworkManagerProtocol {
    var session: Session { get }
    
    func checkEmail(email: String) -> Single<Bool>
    
    func signUp(email: String,
                password: String,
                nickName: String) -> Single<Result<SignUpDTO, SignUpError>>
    
    func login(email: String,
               password: String) -> Single<Result<LoginDTO, LoginError>>
    
    func refreshAccessToken() -> Single<Bool>
    
    func fetchPost(next: String?,
                   category: String) -> Single<Result<PostListDTO,PostError>>
}

