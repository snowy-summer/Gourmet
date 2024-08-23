//
//  EditRecipeTitleCell.swift
//  Gourmet
//
//  Created by 최승범 on 8/22/24.
//

import UIKit
import SnapKit

final class EditRecipeTitleCell: UICollectionViewCell {
    
    private let titleTextField = UITextField()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        configureView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

extension EditRecipeTitleCell {
    
    func updateContent(item: String?) {
        
        titleTextField.text = item
        
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
        contentView.backgroundColor = .lightGray
        contentView.layer.cornerRadius = 8
        contentView.clipsToBounds = true
    }
    
    func configureLayout() {
        
        titleTextField.snp.makeConstraints { make in
            make.directionalVerticalEdges.equalTo(contentView.snp.directionalVerticalEdges)
            make.directionalHorizontalEdges.equalTo(contentView.snp.directionalHorizontalEdges).inset(8)
        }
    }
    
}


