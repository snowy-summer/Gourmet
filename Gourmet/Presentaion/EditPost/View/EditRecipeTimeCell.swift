//
//  EditRecipeTimeCell.swift
//  Gourmet
//
//  Created by 최승범 on 8/22/24.
//

import UIKit
import SnapKit

final class EditRecipeTimeCell: UICollectionViewCell {
    
    private let timeLabel = UILabel()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        configureView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

extension EditRecipeTimeCell {
    
    func updateContent(item: String) {
        timeLabel.text = item
    }
}

//MARK: - Configuraion
extension EditRecipeTimeCell: BaseViewProtocol {
    
    func configureHierarchy() {
        contentView.addSubview(timeLabel)
    }
    
    func configureUI() {

        contentView.backgroundColor = .lightGray
        contentView.layer.cornerRadius = 8
        contentView.clipsToBounds = true
    }
    
    func configureLayout() {
    
        timeLabel.snp.makeConstraints { make in
            make.directionalVerticalEdges.equalTo(contentView.snp.directionalVerticalEdges)
            make.directionalHorizontalEdges.equalTo(contentView.snp.directionalHorizontalEdges).inset(8)
        }
    }
    
}

