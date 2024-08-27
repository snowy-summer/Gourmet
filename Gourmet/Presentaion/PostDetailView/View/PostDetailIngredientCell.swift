//
//  PostDetailIngredientCell.swift
//  Gourmet
//
//  Created by 최승범 on 8/27/24.
//

import UIKit
import SnapKit

final class PostDetailIngredientCell: UICollectionViewCell {
    
    private let nameLabel = UILabel()
    private let valueLabel = UILabel()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        configureView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        
        nameLabel.text = ""
        valueLabel.text = ""
    }
    
}

extension PostDetailIngredientCell {
    
    func updateContent(item: RecipeIngredient) {
        
        // 0.고기 200g\n 
        
        
        nameLabel.text = item.name
        valueLabel.text = item.value
    }
}

//MARK: - Configuraion
extension PostDetailIngredientCell: BaseViewProtocol {
    
    func configureHierarchy() {
        
        contentView.addSubview(nameLabel)
        contentView.addSubview(valueLabel)
    }
    
    func configureUI() {
        
        nameLabel.font = .systemFont(ofSize: 20, weight: .medium)
        valueLabel.font = .systemFont(ofSize: 16, weight: .regular)
        valueLabel.textAlignment = .right
        
//        contentView.backgroundColor = .systemBackground
//        contentView.layer.cornerRadius = 8
//        contentView.clipsToBounds = true
    }
    
    func configureLayout() {
        
        valueLabel.snp.makeConstraints { make in
            make.verticalEdges.equalTo(contentView.snp.verticalEdges)
            make.width.equalTo(contentView.snp.width).multipliedBy(0.3)
            make.trailing.equalTo(contentView.snp.trailing).inset(8)
        }
        
        nameLabel.snp.makeConstraints { make in
            make.verticalEdges.equalTo(contentView.snp.verticalEdges)
            make.leading.equalTo(contentView.snp.leading).offset(8)
            make.trailing.equalTo(valueLabel.snp.leading)
        }
    }
    
}

