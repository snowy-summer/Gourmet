//
//  PostDetailImageCell.swift
//  Gourmet
//
//  Created by 최승범 on 8/26/24.
//

import UIKit
import SnapKit

final class PostDetailImageCell: UICollectionViewCell {

    private let foodImageView = UIImageView()
    
    private let containerView = UIView()
    private let contentStackView = UIStackView()
    private let difficultLevelView = InformationDetailView()
    private let timeView = InformationDetailView()
    private let starView = InformationDetailView()
    
    private let foodNameLabel = UILabel()

    override init(frame: CGRect) {
        super.init(frame: frame)
        
        configureView()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}

extension PostDetailImageCell {
    
    func updateContent(item: PostDTO) {
        
        foodNameLabel.text = item.title
        
        if !item.files.isEmpty {
            NetworkManager.shared.fetchImage(file: item.files.first!) { [weak self] data in
                if let data = data {
                    self?.foodImageView.image = UIImage(data: data)
                }
            }
        }
    }
}

extension PostDetailImageCell: BaseViewProtocol {
    
    func configureHierarchy() {
        
        contentView.addSubview(foodImageView)
        contentView.addSubview(containerView)
        containerView.addSubview(foodNameLabel)
        containerView.addSubview(contentStackView)
        contentStackView.addArrangedSubview(difficultLevelView)
        contentStackView.addArrangedSubview(timeView)
        contentStackView.addArrangedSubview(starView)
    }
    
    func configureUI() {

        foodImageView.contentMode = .scaleAspectFill
        
        containerView.layer.cornerRadius = 16
        containerView.layer.borderWidth = 1
        containerView.backgroundColor = .systemBackground
        
        foodNameLabel.font = .systemFont(ofSize: 20,
                                         weight: .bold)
        foodNameLabel.textAlignment = .center
        
        contentStackView.axis = .horizontal
        contentStackView.distribution = .fillEqually
    }

    func configureLayout() {
        
        foodImageView.snp.makeConstraints { make in
            make.top.equalTo(contentView.snp.top)
            make.directionalHorizontalEdges.equalTo(contentView.snp.directionalHorizontalEdges)
            make.height.equalTo(foodImageView.snp.width)
        }
        
        containerView.snp.makeConstraints { make in
            make.centerY.equalTo(foodImageView.snp.bottom)
            make.directionalHorizontalEdges.equalTo(contentView.snp.directionalHorizontalEdges).inset(32)
        }
        
        foodNameLabel.snp.makeConstraints { make in
            make.bottom.equalTo(containerView.snp.bottom).inset(16)
            make.directionalHorizontalEdges.equalTo(containerView.snp.directionalHorizontalEdges).inset(16)
        }
        
        contentStackView.snp.makeConstraints { make in
            make.top.equalTo(containerView.snp.top).offset(16)
            make.bottom.equalTo(foodNameLabel.snp.top).offset(-16)
            make.directionalHorizontalEdges.equalTo(containerView.snp.directionalHorizontalEdges).inset(16)
        }
        
        
    }
}

