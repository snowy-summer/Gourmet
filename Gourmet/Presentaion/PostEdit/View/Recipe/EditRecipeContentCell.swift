//
//  EditRecipeContentCell.swift
//  Gourmet
//
//  Created by 최승범 on 8/22/24.
//

import UIKit
import SnapKit

final class EditRecipeContentCell: UICollectionViewCell {
    
    private let iconAndTitleView = ImageAndContentView()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        configureView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

extension EditRecipeContentCell {
    
    func updateContent(item: RecipeContent) {
        iconAndTitleView.updateContent(image: item.thumbnailImage,
                                       content: item.content)
    }
}

//MARK: - Configuraion
extension EditRecipeContentCell: BaseViewProtocol {
    
    func configureHierarchy() {
        
        contentView.addSubview(iconAndTitleView)
    }
    
    func configureUI() {

    }
    
    func configureLayout() {
        
        iconAndTitleView.snp.makeConstraints { make in
            make.directionalEdges.equalTo(contentView.snp.directionalEdges)
        }
    }
    
}

