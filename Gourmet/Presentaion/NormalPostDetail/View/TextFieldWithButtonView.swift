//
//  TextFieldWithButtonView.swift
//  Gourmet
//
//  Created by 최승범 on 8/30/24.
//

import UIKit
import SnapKit
import RxSwift
import RxCocoa

protocol TextFieldWithButtonViewDelegate: AnyObject {
    func handleTextFieldText(_ value: String)
}
final class TextFieldWithButtonView: UIView {
    
    private let commentTextField = UITextField()
    private let uploadButton = UIButton()
    
    weak var delegate: TextFieldWithButtonViewDelegate?
    private let disposeBag = DisposeBag()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        configureView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

//MARK: - Cofiguration
extension TextFieldWithButtonView: BaseViewProtocol {
    
    func configureHierarchy() {
        
        addSubview(commentTextField)
        addSubview(uploadButton)
    }
    
    func configureUI() {
        
        commentTextField.placeholder = "댓글을 입력하세요"
        uploadButton.setImage(UIImage(systemName: "paperplane"),
                              for: .normal)
    }
    
    func configureLayout() {
        
        commentTextField.snp.makeConstraints { make in
            make.leading.equalToSuperview().offset(16)
            make.directionalVerticalEdges.equalToSuperview().inset(4)
        }
        
        uploadButton.snp.makeConstraints { make in
            make.leading.equalTo(commentTextField.snp.trailing).offset(16)
            make.trailing.equalTo(self.snp.trailing).inset(8)
            make.directionalVerticalEdges.equalToSuperview().inset(4)
            make.width.equalTo(uploadButton.snp.height)
        }
    }
    
    func configureGestureAndButtonActions() {
        
        uploadButton.rx.tap
            .withLatestFrom(commentTextField.rx.text.orEmpty)
            .bind(with: self) { owner, text in
                owner.delegate?.handleTextFieldText(text)
            }
            .disposed(by: disposeBag)
    }
    
}
