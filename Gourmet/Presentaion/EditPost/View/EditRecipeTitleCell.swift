//
//  EditRecipeTitleCell.swift
//  Gourmet
//
//  Created by 최승범 on 8/22/24.
//

import UIKit
import SnapKit
import RxSwift
import RxCocoa

protocol EditRecipeTitleCellDelegate: AnyObject {
    func updateTitle(_ value: String)
}

final class EditRecipeTitleCell: UICollectionViewCell {
    
    private(set) var contentTextView = UITextView()
//    var type: EnrollSections.Main?
    weak var delegate: EditRecipeTitleCellDelegate?
    private let disposeBag = DisposeBag()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        configureView()
        contentTextView.rx.text.orEmpty
            .debounce(.milliseconds(50), scheduler: MainScheduler.instance)
            .bind(with: self) { owner, text in
                owner.delegate?.updateTitle(text)
            }.disposed(by: disposeBag)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

extension EditRecipeTitleCell {
    
    func updateContent(item: String?) {
        
//        titleTextField.text = item
        
//        guard let type = type else { return }
        if let text = item,
           !text.isEmpty {
            contentTextView.text = text
        } else {
            contentTextView.text = "placeHolder"
        }
    }
}

//MARK: - Configuraion
extension EditRecipeTitleCell: BaseViewProtocol {
    
    func configureHierarchy() {
        contentView.addSubview(contentTextView)
    }
    
    func configureUI() {
        
//        titleTextField.placeholder = "제목을 입력해주세요"
//        titleTextField.font = .systemFont(ofSize: 24, weight: .bold)
//        contentView.backgroundColor = .systemBackground
//        contentView.layer.cornerRadius = 8
//        contentView.clipsToBounds = true
        
        contentTextView.textContainerInset = UIEdgeInsets(top: 8.0,
                                                          left: 8.0,
                                                          bottom: 8.0,
                                                          right: 8.0)
        
        contentTextView.font = .systemFont(ofSize: 17,
                                           weight: .semibold)
        contentTextView.backgroundColor = .clear
        
        contentTextView.delegate = self
    }
    
    func configureLayout() {
        
//        titleTextField.snp.makeConstraints { make in
//            make.directionalVerticalEdges.equalTo(contentView.snp.directionalVerticalEdges)
//            make.directionalHorizontalEdges.equalTo(contentView.snp.directionalHorizontalEdges).inset(8)
//        }
        
        contentTextView.snp.makeConstraints { make in
            make.directionalEdges.equalToSuperview()
        }
    }
    
}

extension EditRecipeTitleCell: UITextViewDelegate {
    
    func textViewDidBeginEditing(_ textView: UITextView) {
        
//        if textView.text == type?.text {
//            contentTextView.text = .none
//        }
//        
//        contentTextView.textColor = .baseFont
    }
    
    func textViewDidChange(_ textView: UITextView) {
        
//        let text = textView.text.trimmingCharacters(in: .whitespacesAndNewlines)
//        
//        if let type = type {
//            delegate?.changeSaveButtonEnabled(text: text,
//                                              type: type)
//        }
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        
//        if textView.text.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty {
//            contentTextView.text = type?.text
//            contentTextView.textColor = .lightGray
//        }
//        
        
    }
    
}
