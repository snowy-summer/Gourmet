//
//  EditRecipeIngredientCell.swift
//  Gourmet
//
//  Created by 최승범 on 8/22/24.
//

import UIKit
import SnapKit

final class EditRecipeIngredientCell: UICollectionViewCell {
    
    private let nameLabel = UILabel()
    private let valueLabel = UILabel()
    private let addImageView = UIImageView()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        configureView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        
        addImageView.isHidden = true
    }
    
}

extension EditRecipeIngredientCell {
    
    func updateContent(item: RecipeIngredient) {
        
        if item.isAddCell {
            addImageView.isHidden = false
            nameLabel.isHidden = true
            valueLabel.isHidden = true
            return
        }
        
        nameLabel.text = item.name
        valueLabel.text = item.value
    }
}

//MARK: - Configuraion
extension EditRecipeIngredientCell: BaseViewProtocol {
    
    func configureHierarchy() {
        
        contentView.addSubview(nameLabel)
        contentView.addSubview(valueLabel)
        contentView.addSubview(addImageView)
    }
    
    func configureUI() {
        
        nameLabel.font = .systemFont(ofSize: 20, weight: .medium)
        valueLabel.font = .systemFont(ofSize: 16, weight: .regular)
        valueLabel.textAlignment = .right
        
        contentView.backgroundColor = .systemBackground
        contentView.layer.cornerRadius = 8
        contentView.clipsToBounds = true
        
        addImageView.image = UIImage(systemName: "plus")
        addImageView.tintColor = .main
        addImageView.isHidden = true
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
        
        addImageView.snp.makeConstraints { make in
            make.size.equalTo(20)
            make.center.equalTo(contentView.snp.center)
        }
    
    }
    
}

