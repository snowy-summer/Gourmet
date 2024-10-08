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
                        PrintDebugger.logError(error)
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
    
    func fetchProfile(completion: @escaping (Result<UserDTO, PostError>) -> Void) {
        
        session.request(ProfileRouter.fetchProfile)
            .responseDecodable(of: UserDTO.self) { response in
                switch response.result {
                case .success(let data):
                    completion(.success(data))
                    
                case .failure(let error):
                    PrintDebugger.logError(error)
                    if let statusCode = response.response?.statusCode,
                       let postError = PostError(rawValue: statusCode) {
                        completion(.failure(postError))
                    } else {
                        PrintDebugger.logError(error)
                    }
                }
            }
    }
    
    func withdraw(completion: @escaping (Result<Bool, PostError>) -> Void) {
        
        session.request(UserRouter.withdraw)
            .response { response in
                switch response.result {
                case .success:
                    completion(.success(true))
                    
                case .failure(let error):
                    
                    if let statusCode = response.response?.statusCode,
                       let postError = PostError(rawValue: statusCode) {
                        completion(.failure(postError))
                    } else {
                        PrintDebugger.logError(error)
                    }
                }
            }
    }
    
    func refreshAccessToken(completion: @escaping (Result<Bool, TokenError>) -> Void) {
        
        let keychainManager = KeychainManager.shared
        
        session.request(TokenRouter.refreshAccessToken)
            .validate(statusCode: 200..<300)
            .responseDecodable(of: RefreshAccessTokenDTO.self) { response in
                switch response.result {
                case .success(let data):
                    keychainManager.save(data.accessToken,
                                         forKey: KeychainKey.accessToken.rawValue)
                    
                    completion(.success(true))
                    
                case .failure(let error):
                    PrintDebugger.logError(error)
                    
                    if let code = response.response?.statusCode,
                       let tokenError = TokenError(rawValue: code) {
                        if tokenError == .expiredRefreshToken {
                            completion(.failure(tokenError))
                        } else {
                            completion(.failure(tokenError))
                            PrintDebugger.logError(tokenError)
                        }
                    }
                }
            }
    }
}

extension NetworkManager {
    
    func fetchPost(category: Category) -> Single<Result<PostListDTO,PostError>> {
        
        return Single.create { [weak self] single -> Disposable in
            
            self?.session.request(PostRouter.fetchPost(next: category.nextCursor,
                                                       limit: 10,
                                                       productId: category.id.productId))
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
                        PrintDebugger.logError(error)
                    }
                }
            }
            return Disposables.create()
        }
    }
    
    func fetchPostById(id: String,
                       completion: @escaping (Result<PostDTO,PostError>) -> Void) {
        
        session.request(PostRouter.fetchPostByPostId(postId: id))
            .validate(statusCode: 200..<300)
            .responseDecodable(of: PostDTO.self) { response in
                switch response.result {
                case .success(let data):
                    completion(.success(data))
                    
                case .failure(let error):
                    if let statusCode = response.response?.statusCode,
                       let postError = PostError(rawValue: statusCode) {
                        completion(.failure(postError))
                    } else {
                        PrintDebugger.logError(error)
                    }
                }
            }
    }
    
    func fetchImage(file: String,
                    completion: @escaping (Result<Data?, PostError>) -> Void) {
        
        session.request(PostRouter.fetchImage(file))
            .validate(statusCode: 200..<300)
            .response { response in
                switch response.result {
                case .success(let data):
                    completion(.success(data))
                    
                case .failure(let error):
                    if let statusCode = response.response?.statusCode,
                       let postError = PostError(rawValue: statusCode) {
                        completion(.failure(postError))
                    } else {
                        PrintDebugger.logError(error)
                    }
                }
            }
    }
    
    func uploadPost(item: UploadPostBodyModel,
                    completion: @escaping (Result<Bool,PostError>) -> Void) {
        
        session.request(PostRouter.uploadPost(item))
            .validate(statusCode: 200..<300)
            .responseDecodable(of: PostDTO.self) { response in
                switch response.result {
                case .success:
                    completion(.success(true))
                    
                case .failure(let error):
                    if let statusCode = response.response?.statusCode,
                       let postError = PostError(rawValue: statusCode) {
                        completion(.failure(postError))
                    } else {
                        PrintDebugger.logError(error)
                    }
                }
            }
        
    }
    
    func uploadImage(_ images: [Data?],
                     completion: @escaping (Result<UploadFileDTO, PostError>) -> Void) {
        
        session.upload(multipartFormData: { multipart in
            for index in 0..<images.count {
                if let image = images[index] {
                    multipart.append(image,
                                     withName: "files",
                                     fileName: "\(index).jpeg",
                                     mimeType: "image/jpeg")
                }
            }
        }, with: PostRouter.uploadFile)
        .responseDecodable(of: UploadFileDTO.self) { response in
            switch response.result {
            case .success(let data):
                completion(.success(data))
                
            case .failure(let error):
                if let statusCode = response.response?.statusCode,
                   let postError = PostError(rawValue: statusCode) {
                    completion(.failure(postError))
                } else {
                    PrintDebugger.logError(error)
                }
            }
        }
    }
    
    func uploadComment(id: String,
                       content: String,
                       completion: @escaping (Result<Bool, PostError>) -> Void) {
        let commentBody = UploadCommentBodyModel(content: content)
        session.request(PostRouter.uploadComment(postId: id,
                                                 body: commentBody))
        .validate(statusCode: 200..<300)
        .response { response in
            switch response.result {
            case .success:
                completion(.success(true))
                
            case .failure(let error):
                if let statusCode = response.response?.statusCode,
                   let postError = PostError(rawValue: statusCode) {
                    completion(.failure(postError))
                } else {
                    PrintDebugger.logError(error)
                }
            }
        }
        
    }
    
    func deletePost(id: String,
                    completion: @escaping (Result<Bool, PostError>) -> Void) {
        session.request(PostRouter.deletePost(postId: id))
            .validate(statusCode: 200..<300)
            .response { response in
                switch response.result {
                case .success:
                    completion(.success(true))
                    
                case .failure(let error):
                    if let statusCode = response.response?.statusCode,
                       let postError = PostError(rawValue: statusCode) {
                        completion(.failure(postError))
                    } else {
                        PrintDebugger.logError(error)
                    }
                }
            }
    }
    
    func checkBill(impUID: String,
                   postID: String,
                   completion: @escaping (Result<Bool, PostError>) -> Void) {
        
        session.request(PaymentRouter.checkBill(impUID: impUID,
                                                postId: postID))
            .validate(statusCode: 200..<300)
            .response { response in
                switch response.result {
                case .success:
                    completion(.success(true))
                    
                case .failure(let error):
                    if let statusCode = response.response?.statusCode,
                       let postError = PostError(rawValue: statusCode) {
                        completion(.failure(postError))
                    } else {
                        PrintDebugger.logError(error)
                    }
                }
            }
    }
}
