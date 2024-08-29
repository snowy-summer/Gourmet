//
//  RecipeCollectionViewCell.swift
//  Gourmet
//
//  Created by 최승범 on 8/20/24.
//

import UIKit
import SnapKit

final class RecipeCollectionViewCell: UICollectionViewCell {
    
    private let thumbnailImageView = UIImageView()
    private let titleLabel = UILabel()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        configureView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        
        thumbnailImageView.image = nil
        titleLabel.text = ""
    }
}

extension RecipeCollectionViewCell {
    
    func updateContent(item: PostDTO) {
        
        if !item.files.isEmpty {
            NetworkManager.shared.fetchImage(file: item.files.first!) { [weak self] data in
                if let data = data {
                    self?.thumbnailImageView.image = UIImage(data: data)
                }
            }
        }
        
        titleLabel.text = item.title
    }
}

//MARK: - Configuraion
extension RecipeCollectionViewCell: BaseViewProtocol {
    
    func configureHierarchy() {
        
        contentView.addSubview(thumbnailImageView)
        contentView.addSubview(titleLabel)
    }
    
    func configureUI() {
        
        thumbnailImageView.backgroundColor = .lightGray
        thumbnailImageView.contentMode = .scaleToFill
        thumbnailImageView.layer.cornerRadius = 8
        thumbnailImageView.clipsToBounds = true
    }
    
    func configureLayout() {
        
        thumbnailImageView.snp.makeConstraints { make in
            make.top.equalTo(contentView.snp.top)
            make.directionalHorizontalEdges.equalTo(contentView.snp.directionalHorizontalEdges)
        }
        
        titleLabel.snp.makeConstraints { make in
            make.top.equalTo(thumbnailImageView.snp.bottom).offset(8)
            make.directionalHorizontalEdges.equalTo(contentView.snp.directionalHorizontalEdges)
            make.bottom.equalTo(contentView.snp.bottom)
        }
    }
    
}
