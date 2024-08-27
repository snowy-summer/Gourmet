//
//  CategoryCell.swift
//  Gourmet
//
//  Created by 최승범 on 8/26/24.
//

import UIKit
import SnapKit

final class CategoryCell: UICollectionViewCell {
    
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
        
        contentView.backgroundColor = .systemBackground
    }
}

extension CategoryCell {
    
    func updateContent(item: Category) {
        
        nameLabel.text = item.id.name
        if item.isSelected {
            contentView.backgroundColor = .lightGray
        }
    }
}


//MARK: - configure
extension CategoryCell: BaseViewProtocol {
    
    func configureHierarchy() {
        
        contentView.addSubview(nameLabel)
    }
    
    func configureUI() {
        
        contentView.layer.cornerRadius = 8
        contentView.layer.borderWidth = 1
    }
    
    func configureLayout() {
        
        nameLabel.snp.makeConstraints { make in
            make.directionalHorizontalEdges.equalTo(contentView.snp.directionalHorizontalEdges).inset(8)
            make.directionalVerticalEdges.equalTo(contentView.snp.directionalVerticalEdges)
        }
    }
}

