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
    
    //user
    func checkEmail(email: String) -> Single<Bool>
    
    func signUp(email: String,
                password: String,
                nickName: String) -> Single<Result<SignUpDTO, SignUpError>>
    
    func login(email: String,
               password: String) -> Single<Result<LoginDTO, LoginError>>
    
    func withdraw(completion: @escaping (Result<Bool, PostError>) -> Void)
    
    func refreshAccessToken(completion: @escaping (Result<Bool, TokenError>) -> Void)
    
    // profile
    func fetchProfile(completion: @escaping (Result<UserDTO, PostError>) -> Void)
    
    //post
    func fetchPost(category: Category) -> Single<Result<PostListDTO,PostError>>
    
    func fetchPostById(id: String,
                       completion: @escaping (Result<PostDTO,PostError>) -> Void)
    
    func uploadPost(item: UploadPostBodyModel,
                    completion: @escaping (Result<Bool,PostError>) -> Void)
    
    func uploadImage(_ images: [Data?],
                     completion: @escaping (Result<UploadFileDTO, PostError>) -> Void)
    
    func uploadComment(id: String,
                       content: String,
                       completion: @escaping (Result<Bool, PostError>) -> Void)
    
    func fetchImage(file: String,
                    completion: @escaping (Result<Data?, PostError>) -> Void)
    
    func deletePost(id: String,
                    completion: @escaping (Result<Bool, PostError>) -> Void)
    
    // payment
    func checkBill(impUID: String,
                   postID: String,
                   completion: @escaping (Result<Bool, PostError>) -> Void)
}

