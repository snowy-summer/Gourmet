//
//  LoginViewController.swift
//  Gourmet
//
//  Created by 최승범 on 8/18/24.
//

import UIKit
import SnapKit
import RxSwift
import RxCocoa

final class LoginViewController: UIViewController {
    
    private let emailLabel = UILabel()
    private let emailTextField = UITextField()
    private let passwordLabel = UILabel()
    private let passwordTextField = UITextField()
    private let loginButton = UIButton()
    private let failLabel = UILabel()
    
    private let viewModel = LoginViewModel()
    private let disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureView()
        bindOutput()
    }
    
}

// MARK: - Logic
extension LoginViewController {
    
    private func bindOutput() {
        
        let input = LoginViewModel.Input(emailText: emailTextField.rx.text,
                                         passwordText: passwordTextField.rx.text,
                                         loginButtonTap: loginButton.rx.tap)
        
        let output = viewModel.transform(input)
        
        output.isLoginSuccess
            .bind(with: self) { owner, value in
                
                if value {
                    owner.navigationController?.pushViewController(NormalPostListViewController(),
                                                                   animated: true)
                } else {
                    owner.failLabel.isHidden = false
                }
            }
            .disposed(by: disposeBag)
    }
}

// MARK: - Configuration
extension LoginViewController: BaseViewProtocol {
    
    func configureHierarchy() {
        
        view.addSubview(emailLabel)
        view.addSubview(emailTextField)
        
        view.addSubview(passwordLabel)
        view.addSubview(passwordTextField)
        
        view.addSubview(loginButton)
        view.addSubview(failLabel)
    }
    
    func configureUI() {
        
        view.backgroundColor = .white
        
        emailTextField.userInfoStyle(placeHolder: "이메일을  입력해주세요")
        passwordTextField.userInfoStyle(placeHolder: "비밀번호를 입력해주세요")
        emailLabel.text = "Email"
        passwordLabel.text = "비밀번호"
        loginButton.normalStyle(title: "로그인",
                                back: .main,
                                fore: .white)
        loginButton.layer.shadowOffset = CGSize(width: 0,
                                                height: 4)
        loginButton.layer.shadowOpacity = 0.2
        
        failLabel.text = "비밀번호나 이메일을 확인해주세요"
        failLabel.textColor = .red
        failLabel.isHidden = true
        
    }
    
    func configureLayout() {
        
        emailLabel.snp.makeConstraints { make in
            make.directionalHorizontalEdges.equalTo(view.safeAreaLayoutGuide).inset(30)
            make.top.equalTo(view.safeAreaLayoutGuide).offset(60)
        }
        
        emailTextField.snp.makeConstraints { make in
            make.height.equalTo(44)
            make.top.equalTo(emailLabel.snp.bottom).offset(8)
            make.directionalHorizontalEdges.equalTo(view.safeAreaLayoutGuide).inset(20)
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
        
        loginButton.snp.makeConstraints { make in
            make.height.equalTo(44)
            make.top.equalTo(passwordTextField.snp.bottom).offset(40)
            make.directionalHorizontalEdges.equalTo(view.safeAreaLayoutGuide).inset(20)
        }
        
        failLabel.snp.makeConstraints { make in
            make.top.equalTo(loginButton.snp.bottom).offset(20)
            make.directionalHorizontalEdges.equalTo(view.safeAreaLayoutGuide).inset(32)
        }
        
    }

}

