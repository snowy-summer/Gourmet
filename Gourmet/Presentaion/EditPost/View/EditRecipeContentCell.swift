//
//  EditRecipeContentCell.swift
//  Gourmet
//
//  Created by 최승범 on 8/22/24.
//

import UIKit
import SnapKit

final class EditRecipeContentCell: UICollectionViewCell {
    
    private let stackView = UIStackView()
    private let thumbnailImageView = UIImageView()
    private let contentTextView = UITextView()
    private let addButton = UIButton()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        configureView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        
        addButton.isHidden = true
        stackView.isHidden = false
    }
}

extension EditRecipeContentCell {
    
    func updateContent(item: RecipeContent) {
        
        if item.isAddCell {
            addButton.isHidden = false
            stackView.isHidden = true
            return
        }
        
        if item.thumbnailImage == nil {
            thumbnailImageView.isHidden = true
        } else {
            thumbnailImageView.image = UIImage(resource: .test1)
        }
        
        contentTextView.text = item.contet
        
        
      
    }
}

//MARK: - Configuraion
extension EditRecipeContentCell: BaseViewProtocol {
    
    func configureHierarchy() {
        
        contentView.addSubview(stackView)
        stackView.addArrangedSubview(thumbnailImageView)
        stackView.addArrangedSubview(contentTextView)
        
        contentView.addSubview(addButton)
    }
    
    func configureUI() {
        
        stackView.spacing = 8
        
        thumbnailImageView.backgroundColor = .lightGray
        thumbnailImageView.layer.cornerRadius = 16
        thumbnailImageView.clipsToBounds = true
        
        contentTextView.font = .systemFont(ofSize: 20, weight: .semibold)
        
        contentView.backgroundColor = .systemBackground
        contentView.layer.cornerRadius = 16
        contentView.clipsToBounds = true
        
        addButton.backgroundColor = .mantis
        addButton.isHidden = true
    }
    
    func configureLayout() {
        
        stackView.snp.makeConstraints { make in
            make.directionalEdges.equalToSuperview().inset(8)
        }
        
        thumbnailImageView.snp.makeConstraints { make in
            make.width.equalTo(stackView.snp.height)
        }
        
        addButton.snp.makeConstraints { make in
            make.size.equalTo(60)
            make.center.equalTo(contentView.snp.center)
        }
    
    }
    
}
