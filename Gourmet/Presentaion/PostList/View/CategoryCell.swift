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

}

extension CategoryCell {
    
    func updateContent(item: Category) {
        
        nameLabel.text = item.id.name
    }
}


//MARK: - configure
extension CategoryCell: BaseViewProtocol {
    
    func configureHierarchy() {
        
        contentView.addSubview(nameLabel)
    }
    
    func configureUI() {
        
        contentView.backgroundColor = .lightGray
        contentView.layer.cornerRadius = 8
    }
    
    func configureLayout() {
        
        nameLabel.snp.makeConstraints { make in
            make.directionalHorizontalEdges.equalTo(contentView.snp.directionalHorizontalEdges).inset(8)
            make.directionalVerticalEdges.equalTo(contentView.snp.directionalVerticalEdges)
        }
    }
}

