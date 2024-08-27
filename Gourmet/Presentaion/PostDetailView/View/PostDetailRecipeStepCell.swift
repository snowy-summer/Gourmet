//
//  PostDetailRecipeStepCell.swift
//  Gourmet
//
//  Created by 최승범 on 8/27/24.
//

import UIKit
import SnapKit

final class PostDetailRecipeStepCell: UICollectionViewCell {
    
    private let stepImageView = UIImageView()
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
        
        stepImageView.image = nil
        valueLabel.text = ""
    }
    
}

extension PostDetailRecipeStepCell {
    
    func updateContent(item: RecipeContent) {
        
        // 0.고기 200g\n
        
//        valueLabel.text = item.content
        
        stepImageView.image = item.thumbnailImage
        valueLabel.text = item.content
    }
}

//MARK: - Configuraion
extension PostDetailRecipeStepCell: BaseViewProtocol {
    
    func configureHierarchy() {
        
        contentView.addSubview(stepImageView)
        contentView.addSubview(valueLabel)
    }
    
    func configureUI() {
        
        stepImageView.contentMode = .scaleAspectFit
        valueLabel.font = .systemFont(ofSize: 16, weight: .regular)
        valueLabel.numberOfLines = .zero
        
        contentView.layer.cornerRadius = 8
        contentView.clipsToBounds = true
        contentView.backgroundColor = .lightGray.withAlphaComponent(0.3)
    }
    
    func configureLayout() {
        
        stepImageView.snp.makeConstraints { make in
            make.top.equalTo(contentView.snp.top)
            make.directionalHorizontalEdges.equalTo(contentView.snp.directionalHorizontalEdges).inset(16)
        }
        
        valueLabel.snp.makeConstraints { make in
            make.top.equalTo(stepImageView.snp.bottom).offset(16)
            make.directionalHorizontalEdges.equalTo(contentView.snp.directionalHorizontalEdges).inset(16)
            make.bottom.equalTo(contentView.snp.bottom).inset(16)
        }
    }
    
}
