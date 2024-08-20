//
//  SignUpViewModel.swift
//  Gourmet
//
//  Created by 최승범 on 8/17/24.
//

import Foundation
import RxSwift
import RxCocoa

final class SignUpViewModel: ViewModelProtocol {
    
    struct Input {
        let emailText: ControlProperty<String?>
        let emailValidCheckTap: ControlEvent<Void>
        
        let passwordText: ControlProperty<String?>
        let nicknaemText: ControlProperty<String?>
        
        let signUpButtonTap: ControlEvent<Void>
    }
    
    struct Output {
        let isEmailValid: PublishSubject<Bool>
        let isSignUpSuccess: PublishSubject<Bool>
    }
    
    private let disposeBag = DisposeBag()
    private let networkManager = NetworkManager.shared
    
    func transform(_ input: Input) -> Output {
        
        let isEmailValid = PublishSubject<Bool>()
        let isSignUpSuccess = PublishSubject<Bool>()
        
        input.emailValidCheckTap
            .withLatestFrom(input.emailText.orEmpty)
            .debounce(.milliseconds(10), scheduler: MainScheduler.instance)
            .flatMapLatest { [weak self] email in
                self?.networkManager.checkEmail(email: email) ?? .just(false)
            }
            .bind(to: isEmailValid)
            .disposed(by: disposeBag)
        
        let signUpInformation = Observable.combineLatest(input.emailText.orEmpty,
                                                         input.passwordText.orEmpty,
                                                         input.nicknaemText.orEmpty)
        
        input.signUpButtonTap
            .withLatestFrom(signUpInformation)
            .flatMapLatest { [weak self] email, password, nickname in
                self?.networkManager.signUp(email: email,
                                            password: password,
                                            nickName: nickname) ?? .just(.failure(.serverError))
            }
            .bind { value in
                
                switch value {
                case .success(let data):
                    isSignUpSuccess.onNext(true)
                    
                case .failure(let error):
                    isSignUpSuccess.onNext(false)
                }
            }
            .disposed(by: disposeBag)
        
        return Output(isEmailValid: isEmailValid, isSignUpSuccess: isSignUpSuccess)
    }
    
}
