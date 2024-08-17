//
//  OnboardingViewController.swift
//  Gourmet
//
//  Created by 최승범 on 8/17/24.
//

import UIKit
import RxSwift
import RxCocoa
import SnapKit

final class OnboardingViewController: UIViewController {
    
    private let mainImageView = UIImageView()
    private let titleLabel = UILabel()
    private let loginButton = UIButton()
    private let signUpButton = UIButton()
    private let disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureView()
    }
    
}

extension OnboardingViewController {

    
}

//MARK: - Configuration
extension OnboardingViewController: BaseViewProtocol {
    
    func configureHierarchy() {
        
        view.addSubview(mainImageView)
        view.addSubview(titleLabel)
        view.addSubview(loginButton)
        view.addSubview(signUpButton)
    }
    
    func configureUI() {
        
        view.backgroundColor = .white
        
        mainImageView.backgroundColor = .lightGray
        titleLabel.text = "테스트"
        titleLabel.textAlignment = .center
        titleLabel.font = .systemFont(ofSize: 36, weight: .black)
        
        loginButton.normalStyle(title: "로그인",
                                back: .main,
                                fore: .white)
        signUpButton.normalStyle(title: "회원가입",
                                 back: .white,
                                 fore: .main)
    }
    
    func configureLayout() {
        
        loginButton.snp.makeConstraints { make in
            make.bottom.equalTo(view.safeAreaLayoutGuide).inset(32)
            make.directionalHorizontalEdges.equalTo(view.safeAreaLayoutGuide).inset(20)
            make.height.equalTo(44)
        }
        
        signUpButton.snp.makeConstraints { make in
            make.bottom.equalTo(loginButton.snp.top).offset(-8)
            make.directionalHorizontalEdges.equalTo(view.safeAreaLayoutGuide).inset(20)
            make.height.equalTo(44)
        }
        
        titleLabel.snp.makeConstraints { make in
            make.centerY.equalTo(view.snp.centerY).offset(60)
            make.directionalHorizontalEdges.equalTo(view.safeAreaLayoutGuide).inset(32)
            make.height.equalTo(56)
        }
        
        mainImageView.snp.makeConstraints { make in
            make.bottom.equalTo(titleLabel.snp.top).offset(-24)
            make.directionalHorizontalEdges.equalTo(view.safeAreaLayoutGuide).inset(32)
            make.top.equalTo(view.safeAreaLayoutGuide)
        }
    }

    func configureGestureAndButtonActions() {
        
        loginButton.rx.tap
            .bind(with: self) { owner, _ in
//                owner.navigationController?.pushViewController(LoginViewController(),
//                                                         animated: true)
            }.disposed(by: disposeBag)
        
        signUpButton.rx.tap
            .bind(with: self) { owner, _ in
//                owner.navigationController?.pushViewController(SignUpViewController(),
//                                                         animated: true)
            }.disposed(by: disposeBag)
        
        
    }
}

