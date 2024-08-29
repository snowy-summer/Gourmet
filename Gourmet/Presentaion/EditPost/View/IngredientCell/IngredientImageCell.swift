//
//  IngredientImageCell.swift
//  Gourmet
//
//  Created by 최승범 on 8/28/24.
//

import UIKit
import SnapKit

final class IngredientImageCell: UICollectionViewCell {
    
    private let imageView = UIImageView()
    
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
        contentView.layer.borderWidth = 0
    }
}

extension IngredientImageCell {
    
    func updateContent(item: EditRecipeIngredient) {
        
        imageView.image = UIImage(named: item.type.imageName)
        
        if item.isSelected {
            contentView.layer.borderWidth = 2
            contentView.layer.cornerRadius = 8
        }
    }
}


//MARK: - configure
extension IngredientImageCell: BaseViewProtocol {
    
    func configureHierarchy() {
        
        contentView.addSubview(imageView)
    }
    
    func configureUI() {
        
        imageView.image = UIImage(systemName: "star")
        contentView.backgroundColor = .systemBackground
        contentView.layer.cornerRadius = 8
    }
    
    func configureLayout() {
        
        imageView.snp.makeConstraints { make in
            make.directionalEdges.equalToSuperview().inset(4)
        }
    }
}
