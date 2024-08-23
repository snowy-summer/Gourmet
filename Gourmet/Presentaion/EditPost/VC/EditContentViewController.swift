//
//  EditContentViewController.swift
//  Gourmet
//
//  Created by 최승범 on 8/23/24.
//

import UIKit
import SnapKit
import RxSwift
import RxCocoa

protocol EditContentViewDelegate: AnyObject {
    func dismissView(item: RecipeIngredient)
}

final class EditContentViewController: UIViewController {
 
    private let stackview = UIStackView()
    private let imageView = UIImageView()
    private let contentTextView = UITextView()
    
    private var content: RecipeContent
    
    weak var delegate: EditContentViewDelegate?
    private let disposeBag = DisposeBag()
    
    init(content: RecipeContent) {
        self.content = content.isAddCell ? RecipeContent(thumbnailImage: nil, contet: "") : content
        super.init(nibName: nil, bundle: nil)
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureView()
    }
    
}

// MARK: - Configuration
extension EditContentViewController: BaseViewProtocol {
    
    func configureHierarchy() {
        
        view.addSubview(nameLabel)
        view.addSubview(nameTextField)
        
        view.addSubview(valueLabel)
        view.addSubview(valueTextField)
        
        view.addSubview(saveButton)
    }
    
    func configureUI() {
        
        view.backgroundColor = .white
        
        nameTextField.infoStyle(placeHolder: "재료를 입력해주세요")
        valueTextField.infoStyle(placeHolder: "용량을 입력해주세요 ex) 3개, 200g")
        nameLabel.text = "재료"
        valueLabel.text = "용량"
        saveButton.normalStyle(title: "저장",
                               back: .main,
                               fore: .white)
        saveButton.layer.shadowOffset = CGSize(width: 0,
                                               height: 4)
        saveButton.layer.shadowOpacity = 0.2
        
        if !ingredient.isAddCell {
            nameTextField.text = ingredient.name
            valueTextField.text = ingredient.value
        }
    }
    
    func configureLayout() {
        
        nameLabel.snp.makeConstraints { make in
            make.directionalHorizontalEdges.equalTo(view.safeAreaLayoutGuide).inset(30)
            make.top.equalTo(view.safeAreaLayoutGuide).offset(60)
        }
        
        nameTextField.snp.makeConstraints { make in
            make.height.equalTo(44)
            make.top.equalTo(nameLabel.snp.bottom).offset(8)
            make.directionalHorizontalEdges.equalTo(view.safeAreaLayoutGuide).inset(20)
        }
        
        valueLabel.snp.makeConstraints { make in
            make.top.equalTo(nameTextField.snp.bottom).offset(20)
            make.directionalHorizontalEdges.equalTo(view.safeAreaLayoutGuide).inset(30)
        }
        
        valueTextField.snp.makeConstraints { make in
            make.height.equalTo(44)
            make.top.equalTo(valueLabel.snp.bottom).offset(8)
            make.directionalHorizontalEdges.equalTo(view.safeAreaLayoutGuide).inset(20)
        }
        
        saveButton.snp.makeConstraints { make in
            make.height.equalTo(44)
            make.top.equalTo(valueTextField.snp.bottom).offset(40)
            make.directionalHorizontalEdges.equalTo(view.safeAreaLayoutGuide).inset(20)
        }
        
    }
    
    func configureGestureAndButtonActions() {
        
        saveButton.rx.tap
            .withLatestFrom(Observable.combineLatest(nameTextField.rx.text.orEmpty,
                                                     valueTextField.rx.text.orEmpty))
            .bind(with: self) { owner, nameValue in
                let (name, value) = nameValue
                owner.ingredient.name = name
                owner.ingredient.value = value
                
                owner.dismiss(animated: true) {
                    owner.delegate?.dismissView(item: owner.ingredient)
                }
            }
            .disposed(by: disposeBag)
    }
    
}


