//
//  CategorycomponentCell.swift
//  Gourmet
//
//  Created by 최승범 on 8/29/24.
//

import UIKit
import SnapKit
import RxSwift
import RxCocoa

final class CategorycomponentCell: UICollectionViewCell {
    
    private let imageView = UIImageView()
    private let nameLabel = UILabel()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        configureView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        
        imageView.image = nil
        nameLabel.text = nil
        contentView.layer.borderWidth = 0
    }
}

extension CategorycomponentCell {
    
    func updateContent(item: EditRecipeFoodCategory) {
        
        imageView.image = UIImage(named: item.category.iconName)
        nameLabel.text = item.category.name
        
        if item.isSelected {
            contentView.layer.borderWidth = 2
            contentView.layer.cornerRadius = 8
        }
    }
}

extension CategorycomponentCell: BaseViewProtocol {
    
    func configureHierarchy() {
        
        contentView.addSubview(imageView)
        contentView.addSubview(nameLabel)
    }
    
    func configureUI() {
        
        imageView.layer.cornerRadius = 8
        imageView.clipsToBounds = true
        nameLabel.textAlignment = .center
        nameLabel.numberOfLines = .zero
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
            make.bottom.equalTo(contentView.snp.bottom).inset(4)
        }
        
    }
    
}
