//
//  EditRecipeHeaderCell.swift
//  Gourmet
//
//  Created by 최승범 on 8/28/24.
//

import UIKit
import SnapKit

final class EditRecipeHeaderCell: UICollectionViewCell {
    
    private let iconAndTitleView = IconAndTitleView()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        configureView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

extension EditRecipeHeaderCell {
    
    func updateContent(item: RecipeIngredient) {
        
    }
}

//MARK: - Configuraion
extension EditRecipeHeaderCell: BaseViewProtocol {
    
    func configureHierarchy() {
        
        contentView.addSubview(iconAndTitleView)
    }
    
    func configureUI() {
        
    }
    
    func configureLayout() {
        
        iconAndTitleView.snp.makeConstraints { make in
            make.directionalEdges.equalTo(contentView.snp.directionalEdges).inset(8)
        }
    }
    
}


