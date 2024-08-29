//
//  EditRecipeCategoryCell.swift
//  Gourmet
//
//  Created by 최승범 on 8/29/24.
//

import UIKit
import SnapKit

final class EditRecipeCategoryCell: UICollectionViewCell {
    
    private let imageView = UIImageView()
    private let nameLabel = UILabel()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        configureView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension EditRecipeCategoryCell {
    
    func updateContent(item: FoodCategory) {
        
        imageView.image = UIImage(named: item.iconName)
        nameLabel.text = item.name
    }
}

extension EditRecipeCategoryCell: BaseViewProtocol {
    
    func configureHierarchy() {
        
        contentView.addSubview(imageView)
        contentView.addSubview(nameLabel)
    }
    
    func configureUI() {
        
        imageView.layer.cornerRadius = 8
        imageView.clipsToBounds = true
        nameLabel.textAlignment = .center
    }
    
    func configureLayout() {
        
        imageView.snp.makeConstraints { make in
            make.top.equalToSuperview().inset(4)
            make.directionalHorizontalEdges.equalToSuperview().inset(4)
            make.height.equalTo(imageView.snp.width)
        }
        
        nameLabel.snp.makeConstraints { make in
            make.top.equalTo(imageView.snp.bottom).offset(4)
            make.directionalHorizontalEdges.equalToSuperview().inset(4)
            make.bottom.equalTo(contentView.snp.bottom).inset(8)
        }
        
    }
    
    
    
}
