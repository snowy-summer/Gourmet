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
    }
}

extension IngredientImageCell {
    
    func updateContent(item: IngredientType) {
        
        imageView.image = UIImage(named: item.imageName)
    }
}


//MARK: - configure
extension IngredientImageCell: BaseViewProtocol {
    
    func configureHierarchy() {
        
        contentView.addSubview(imageView)
    }
    
    func configureUI() {
        
        imageView.image = UIImage(systemName: "star")
        contentView.layer.cornerRadius = 8
        contentView.layer.borderWidth = 1
    }
    
    func configureLayout() {
        
        imageView.snp.makeConstraints { make in
            make.directionalEdges.equalToSuperview().inset(4)
        }
    }
}
