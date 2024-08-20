//
//  NetworkManager.swift
//  Gourmet
//
//  Created by 최승범 on 8/16/24.
//

import Foundation
import Alamofire
import RxSwift

final class NetworkManager: NetworkManagerProtocol {
    
    static let shared = NetworkManager()
    var session: Session = .default
    
    private init() {}
    
    func fetchData<T: Decodable>(_ object: T.Type,
                                 router: URLRequestConvertible,
                                 completionHandler: @escaping (Result<T,Error>) -> Void) {
        
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

//MARK: - Network User
extension NetworkManager {
    
    func checkEmail(email: String) -> Single<Bool> {
        
        return Single.create { [weak self] single -> Disposable in
            self?.session.request(UserRouter.checkValidEmail(email))
                .validate(statusCode: 200..<300)
                .response { response in
                    switch response.result {
                    case .success(_):
                        single(.success(true))
                        
                    case .failure(_):
                        single(.success(false))
                    }
                }
            
            return Disposables.create()
        }
        
    }
    
    func signUp(email: String,
                password: String,
                nickName: String) -> Single<Result<SignUpDTO, SignUpError>> {
        
        return Single.create { [weak self] single -> Disposable in
            
            let body = SignUpBodyModel(email: email,
                                       password: password,
                                       nick: nickName,
                                       phoneNum: nil,
                                       birthDay: nil)
            
            self?.session.request(UserRouter.signUp(body: body))
                .validate(statusCode: 200..<300)
                .responseDecodable(of: SignUpDTO.self) { response in
                    switch response.result {
                    case .success(let data):
                        single(.success(.success(data)))
                        
                    case .failure:
                        if let statusCode = response.response?.statusCode,
                           let signUpError = SignUpError(rawValue: statusCode) {
                            single(.success(.failure(signUpError)))
                        } else {
                            single(.success(.failure(.serverError)))
                        }
                    }
                }
            return Disposables.create()
        }
        
    }
    
    func login(email: String,
               password: String) -> Single<Result<LoginDTO, LoginError>> {
        
        return Single.create { [weak self] single -> Disposable in
            
            let body = LoginBodyModel(email: email,
                                      password: password)
            
            self?.session.request(UserRouter.login(body: body))
                .validate(statusCode: 200..<300)
                .responseDecodable(of: LoginDTO.self) { response in
                    switch response.result {
                    case .success(let data):
                        single(.success(.success(data)))
                        
                    case .failure(let error):
                        if let statusCode = response.response?.statusCode,
                           let loginError = LoginError(rawValue: statusCode) {
                            single(.success(.failure(loginError)))
                        } else {
                            single(.success(.failure(LoginError.serverError)))
                        }
                    }
                }
            return Disposables.create()
        }
    }
    
    func refreshAccessToken() -> Single<Bool> {
        
        let keychainManager = KeychainManager.shared
        
        return Single.create { [weak self] single -> Disposable in
            
            self?.session.request(TokenRouter.refreshAccessToken)
                .validate(statusCode: 200..<300)
                .responseDecodable(of: RefreshAccessTokenDTO.self) { response in
                    switch response.result {
                    case .success(let data):
                        keychainManager.save(data.accessToken,
                                             forKey: KeychainKey.accessToken.rawValue)
                        
                        single(.success(true))
                        
                    case .failure(let error):
                        print(error)
                        single(.success(false))
                    }
                }
            return Disposables.create()
        }
    }
}

extension NetworkManager {
    
    func fetchNormalPost(next: String?) -> Single<Result<PostListDTO,PostError>> {
        
        return Single.create { [weak self] single -> Disposable in
            
            self?.session.request(PostRouter.fetchPost(next: next,
                                                       limit: 10,
                                                       productId: "Gourmet_normal"))
            .validate(statusCode: 200..<300)
            .responseDecodable(of: PostListDTO.self) { response in
                switch response.result {
                case .success(let data):
                    single(.success(.success(data)))
                    
                case .failure(let error):
                    if let statusCode = response.response?.statusCode,
                       let postError = PostError(rawValue: statusCode) {
                        single(.success(.failure(postError)))
                    } else {
                        print(error)
                        single(.success(.failure(PostError.serverError)))
                    }
                }
            }
            return Disposables.create()
        }
    }
}
