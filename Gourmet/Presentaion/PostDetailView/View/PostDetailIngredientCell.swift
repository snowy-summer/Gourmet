//
//  PostDetailIngredientCell.swift
//  Gourmet
//
//  Created by 최승범 on 8/27/24.
//

import UIKit
import SnapKit

final class PostDetailIngredientCell: UICollectionViewCell {
    
    private let imageView = UIImageView()
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
        
        nameLabel.text = item.name
        valueLabel.text = item.value
    }
}

//MARK: - Configuraion
extension PostDetailIngredientCell: BaseViewProtocol {
    
    func configureHierarchy() {
        
        contentView.addSubview(imageView)
        contentView.addSubview(nameLabel)
        contentView.addSubview(valueLabel)
    }
    
    func configureUI() {
        
        imageView.image = UIImage(systemName: "star")
        nameLabel.font = .systemFont(ofSize: 16, weight: .medium)
        valueLabel.font = .systemFont(ofSize: 14, weight: .regular)
        valueLabel.textColor = .lightGray
    }
    
    func configureLayout() {
        
        imageView.snp.makeConstraints { make in
            make.top.equalTo(contentView.snp.top)
            make.directionalHorizontalEdges.equalTo(contentView.snp.directionalHorizontalEdges)
            make.height.equalTo(imageView.snp.width)
        }
        
        nameLabel.snp.makeConstraints { make in
            make.top.equalTo(imageView.snp.bottom)
            make.directionalHorizontalEdges.equalTo(contentView.snp.directionalHorizontalEdges)
        }
        
        valueLabel.snp.makeConstraints { make in
            make.top.equalTo(nameLabel.snp.bottom)
            make.directionalHorizontalEdges.equalTo(contentView.snp.directionalHorizontalEdges)
        }
        
    }
    
}

