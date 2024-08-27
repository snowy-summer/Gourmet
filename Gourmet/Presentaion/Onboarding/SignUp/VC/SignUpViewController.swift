//
//  SignUpViewController.swift
//  Gourmet
//
//  Created by 최승범 on 8/17/24.
//

import UIKit
import SnapKit
import RxSwift
import RxCocoa

final class SignUpViewController: UIViewController {
    
    private let emailLabel = UILabel()
    private let emailTextField = UITextField()
    
    private let passwordLabel = UILabel()
    private let passwordTextField = UITextField()
    private let nicknameLabel = UILabel()
    private let nicknameTextField = UITextField()
    
    private let emailValidCheckButton = UIButton()
    private let signUpButton = UIButton()
    
    private let viewModel = SignUpViewModel(networkManager: NetworkManager.shared)
    private let disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureView()
        bindOutput()
    }
    
}

// MARK: - Binding
extension SignUpViewController {
    
    private func bindOutput() {
        
        let input = SignUpViewModel.Input(emailText: emailTextField.rx.text,
                                          emailValidCheckTap: emailValidCheckButton.rx.tap,
                                          passwordText: passwordTextField.rx.text,
                                          nicknaemText: nicknameTextField.rx.text,
                                          signUpButtonTap: signUpButton.rx.tap)
        
        let output = viewModel.transform(input)
        
        output.isEmailValid
            .bind(with: self) { owner, isValid in
                
                let color = isValid ? UIColor.main.cgColor : UIColor.red.cgColor
                owner.emailTextField.layer.borderWidth = 1
                owner.emailTextField.layer.borderColor = color
                
            }.disposed(by: disposeBag)
        
        output.isSignUpSuccess
            .bind(with: self) { owner, value in
                
                if value {
                    owner.resetToTabBar()
                }
                
            }.disposed(by: disposeBag)
        
    }
}

//MARK: - Configuration
extension SignUpViewController: BaseViewProtocol {
    
    func configureHierarchy() {
        
        view.addSubview(emailLabel)
        view.addSubview(emailTextField)
        view.addSubview(emailValidCheckButton)
        
        view.addSubview(passwordLabel)
        view.addSubview(passwordTextField)
        view.addSubview(nicknameLabel)
        view.addSubview(nicknameTextField)
        
        view.addSubview(signUpButton)
    }
    
    func configureUI() {
        
        view.backgroundColor = .white
        
        emailLabel.text = "Email"
        emailTextField.infoStyle(placeHolder: "이메일을  입력해주세요")
        
        passwordLabel.text = "비밀번호"
        passwordTextField.infoStyle(placeHolder: "비밀번호를 입력해주세요")
        passwordTextField.isSecureTextEntry = true
        let button = UIButton(type: .system)
        var configuration = UIButton.Configuration.plain()
        configuration.image = UIImage(systemName: "eye.fill")
        configuration.imagePadding = -16
        
        configuration.preferredSymbolConfigurationForImage = UIImage.SymbolConfiguration(pointSize: 14)
        button.configuration = configuration
        button.tintColor = .lightGray
        button.rx.tap.bind {
            
        }.disposed(by: disposeBag)
        
        passwordTextField.rightView = button
        passwordTextField.rightViewMode = .always
        nicknameLabel.text = "닉네임"
        nicknameTextField.infoStyle(placeHolder: "닉네임을 입력해주세요")
        
        emailValidCheckButton.normalStyle(title: "확인",
                                          back: .main,
                                          fore: .white,
                                          fontSize: 12)
        
        signUpButton.normalStyle(title: "회원가입",
                                back: .main,
                                fore: .white)
        signUpButton.layer.shadowOffset = CGSize(width: 0,
                                                height: 4)
        signUpButton.layer.shadowOpacity = 0.2
        
    }
    
    func configureLayout() {
        
        emailLabel.snp.makeConstraints { make in
            make.directionalHorizontalEdges.equalTo(view.safeAreaLayoutGuide).inset(30)
            make.top.equalTo(view.safeAreaLayoutGuide).offset(60)
        }
        
        emailValidCheckButton.snp.makeConstraints { make in
            make.height.equalTo(44)
            make.width.equalTo(60)
            make.top.equalTo(emailLabel.snp.bottom).offset(8)
            make.trailing.equalTo(view.safeAreaLayoutGuide).inset(20)
        }
        
        emailTextField.snp.makeConstraints { make in
            make.height.equalTo(44)
            make.top.equalTo(emailLabel.snp.bottom).offset(8)
            make.leading.equalTo(view.safeAreaLayoutGuide).inset(20)
            make.trailing.equalTo(emailValidCheckButton.snp.leading).offset(-8)
        }
        
        passwordLabel.snp.makeConstraints { make in
            make.top.equalTo(emailTextField.snp.bottom).offset(20)
            make.directionalHorizontalEdges.equalTo(view.safeAreaLayoutGuide).inset(30)
        }
        
        passwordTextField.snp.makeConstraints { make in
            make.height.equalTo(44)
            make.top.equalTo(passwordLabel.snp.bottom).offset(8)
            make.directionalHorizontalEdges.equalTo(view.safeAreaLayoutGuide).inset(20)
        }
        
        nicknameLabel.snp.makeConstraints { make in
            make.top.equalTo(passwordTextField.snp.bottom).offset(20)
            make.directionalHorizontalEdges.equalTo(view.safeAreaLayoutGuide).inset(30)
        }
        
        nicknameTextField.snp.makeConstraints { make in
            make.height.equalTo(44)
            make.top.equalTo(nicknameLabel.snp.bottom).offset(8)
            make.directionalHorizontalEdges.equalTo(view.safeAreaLayoutGuide).inset(20)
        }
        
        signUpButton.snp.makeConstraints { make in
            make.height.equalTo(44)
            make.top.equalTo(nicknameTextField.snp.bottom).offset(40)
            make.directionalHorizontalEdges.equalTo(view.safeAreaLayoutGuide).inset(20)
        }
        
    }
    
}

