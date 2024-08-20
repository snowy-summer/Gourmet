//
//  LoginViewModel.swift
//  Gourmet
//
//  Created by 최승범 on 8/18/24.
//

import Foundation
import RxSwift
import RxCocoa

final class LoginViewModel: ViewModelProtocol {
    
    struct Input {
        let emailText: ControlProperty<String?>
        let passwordText: ControlProperty<String?>
        let loginButtonTap: ControlEvent<Void>
    }
    
    struct Output {
        let isLoginSuccess: PublishSubject<Bool>
    }
    
    private let networkManager = NetworkManager()
    private let disposeBag = DisposeBag()
    
    func transform(_ input: Input) -> Output {
        
        let isLoginSuccess = PublishSubject<Bool>()
        
        let information = Observable.combineLatest(input.emailText.orEmpty,
                                                   input.passwordText.orEmpty)
        input.loginButtonTap
            .withLatestFrom(information)
            .flatMapLatest { [weak self] email, password in
                self?.networkManager.login(email: email,
                                           password: password) ?? .just(.failure(LoginError.serverError))
            }
            .bind(with: self) { owner,value in
                
                switch value {
                case .success(let data):
                    owner.storeTokens(accessToken: data.accessToken,
                                      refreshToken: data.refreshToken)
                    isLoginSuccess.onNext(true)
                    
                case .failure(let error):
                    isLoginSuccess.onNext(false)
                }
            }
            .disposed(by: disposeBag)
        
        return Output(isLoginSuccess: isLoginSuccess)
    }
}

extension LoginViewModel {
    
    func storeTokens(accessToken: String,
                     refreshToken: String) {
        let keychain = KeychainManager.shared
        
        let accessTokenKey = "accessToken"
        let refreshTokenKey = "refreshToken"
        
        keychain.save(accessToken, forKey: accessTokenKey)
        keychain.save(refreshToken, forKey: refreshTokenKey)
    }
}
