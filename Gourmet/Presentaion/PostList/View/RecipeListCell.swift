//
//  RecipeListCell.swift
//  Gourmet
//
//  Created by 최승범 on 8/26/24.
//

import UIKit
import SnapKit

final class RecipeListCell: UICollectionViewCell {

    private let foodImageView = UIImageView()
    
    private let contentStackView = UIStackView()
    private let foodNameLabel = UILabel()
    private let likeView = IconLabelView()
    private let timeView = IconLabelView()
    private let descriptionLabel = UILabel()

    override init(frame: CGRect) {
        super.init(frame: frame)
        
        configureView()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}

extension RecipeListCell {
    
    func updateContent(item: PostDTO) {
        
        foodNameLabel.text = item.title
        descriptionLabel.text = item.content
        
        if !item.files.isEmpty {
            NetworkManager.shared.fetchImage(file: item.files.first!) { [weak self] data in
                if let data = data {
                    self?.foodImageView.image = UIImage(data: data)
                }
            }
        }
    }
}

extension RecipeListCell: BaseViewProtocol {
    
    func configureHierarchy() {
        
        contentView.addSubview(foodImageView)
        contentView.addSubview(foodNameLabel)
        contentView.addSubview(likeView)
        contentView.addSubview(timeView)
        contentView.addSubview(descriptionLabel)
    }
    
    func configureUI() {
        
        contentView.layer.cornerRadius = 8
        contentView.layer.borderWidth = 1
        contentView.layer.borderColor = UIColor.gray.withAlphaComponent(0.2).cgColor

        foodImageView.contentMode = .scaleAspectFill
        
        DispatchQueue.main.async {
            self.foodImageView.layer.cornerRadius = self.foodImageView.frame.width / 2
            self.foodImageView.clipsToBounds = true
        }
        
        foodNameLabel.font = .systemFont(ofSize: 20,
                                         weight: .bold)
        
        descriptionLabel.font = .systemFont(ofSize: 16,
                                            weight: .regular)
        descriptionLabel.textColor = .lightGray
        descriptionLabel.numberOfLines = 2
        
        
        foodImageView.backgroundColor = .lightGray
        foodNameLabel.text = "aaaaa"
        descriptionLabel.text = "cccccc"
        
        likeView.configureIcon(icon: .like)
        timeView.configureIcon(icon: .time)
        
    }

    func configureLayout() {
        
        foodImageView.snp.makeConstraints { make in
            make.directionalVerticalEdges.leading.equalToSuperview().inset(16)
            make.width.equalTo(foodImageView.snp.height)
        }
        
        foodNameLabel.snp.makeConstraints { make in
            make.top.equalTo(foodImageView.snp.top).offset(20)
            make.leading.equalTo(foodImageView.snp.trailing).offset(16)
            make.trailing.equalTo(contentView.snp.trailing).inset(8)
        }
        
        likeView.snp.makeConstraints { make in
            make.bottom.equalTo(foodImageView.snp.bottom).inset(20)
            make.leading.equalTo(foodImageView.snp.trailing).offset(16)
        }
        
        timeView.snp.makeConstraints { make in
            make.bottom.equalTo(foodImageView.snp.bottom).inset(20)
            make.leading.equalTo(likeView.snp.trailing).offset(8)
        }
        
        descriptionLabel.snp.makeConstraints { make in
            make.top.equalTo(foodNameLabel.snp.bottom).offset(8)
            make.leading.equalTo(foodImageView.snp.trailing).offset(16)
            make.trailing.equalTo(contentView.snp.trailing).inset(8)
        }
        
        
    }
}
