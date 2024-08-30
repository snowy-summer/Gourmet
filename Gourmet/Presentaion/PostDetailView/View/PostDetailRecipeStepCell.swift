//
//  PostDetailRecipeStepCell.swift
//  Gourmet
//
//  Created by 최승범 on 8/27/24.
//

import UIKit
import SnapKit

final class PostDetailRecipeStepCell: UICollectionViewCell {
    
    private let stackView = UIStackView()
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
        stepImageView.isHidden = true
        valueLabel.text = ""
    }
    
}

extension PostDetailRecipeStepCell {
    
    func updateContent(item: RecipeContent) {
        
        if let image = item.thumbnailImage {
            stepImageView.image = image
            stepImageView.isHidden = false
        }
        valueLabel.text = item.content
    }
}

//MARK: - Configuraion
extension PostDetailRecipeStepCell: BaseViewProtocol {
    
    func configureHierarchy() {
        
        contentView.addSubview(stackView)
        stackView.addArrangedSubview(stepImageView)
        stackView.addArrangedSubview(valueLabel)
    }
    
    func configureUI() {
        
        stackView.axis = .vertical
        stackView.distribution = .fill
        stackView.alignment = .center
        valueLabel.font = .systemFont(ofSize: 16,
                                      weight: .medium)
        valueLabel.numberOfLines = .zero
        stepImageView.isHidden = true
        stepImageView.layer.cornerRadius = 8
        stepImageView.clipsToBounds = true
        
        contentView.layer.cornerRadius = 8
        contentView.clipsToBounds = true
        contentView.backgroundColor = .lightGray.withAlphaComponent(0.3)
    }
    
    func configureLayout() {
        
        stackView.snp.makeConstraints { make in
            make.directionalEdges.equalTo(contentView.snp.directionalEdges).inset(16)
        }
        
        stepImageView.snp.makeConstraints { make in
            make.width.equalTo(stackView.snp.width).multipliedBy(0.5)
            make.height.equalTo(stepImageView.snp.width).multipliedBy(0.75)
        }
    }
    
}
