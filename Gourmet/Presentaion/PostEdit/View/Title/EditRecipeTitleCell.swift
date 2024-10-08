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
    
    private(set) var titleTextField = UITextField()
    weak var delegate: EditRecipeTitleCellDelegate?
    private let disposeBag = DisposeBag()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        configureView()
        titleTextField.rx.text.orEmpty
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
        
        if let text = item,
            !text.isEmpty {
            titleTextField.text = text
        } else {
            titleTextField.text = ""
        }
    }
}

//MARK: - Configuraion
extension EditRecipeTitleCell: BaseViewProtocol {
    
    func configureHierarchy() {
        contentView.addSubview(titleTextField)
    }
    
    func configureUI() {
        
        titleTextField.placeholder = "제목을 입력해주세요"
        titleTextField.font = .systemFont(ofSize: 24, weight: .bold)
        titleTextField.backgroundColor = .clear
    }
    
    func configureLayout() {
        
        titleTextField.snp.makeConstraints { make in
            make.directionalVerticalEdges.equalTo(contentView.snp.directionalVerticalEdges)
            make.directionalHorizontalEdges.equalTo(contentView.snp.directionalHorizontalEdges).inset(8)
            make.height.equalTo(60)
        }
    }
    
}
