//
//  NormalPostCell.swift
//  Gourmet
//
//  Created by 최승범 on 8/18/24.
//

import UIKit
import SnapKit

final class PostCollectionViewCell: UICollectionViewCell {
    
    private let profileImageView = UIImageView()
    private let nicknameLabel = UILabel()
    private let titleLabel = UILabel()
    private let contentsLabel = UILabel()
    private let likeView = IconLabelView()
    private let timeView = IconLabelView()
    private let commentsView = IconLabelView()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
       configureView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

extension PostCollectionViewCell {
    
    func updateContent(item: PostDTO) {
        
        nicknameLabel.text = item.creator.nick
        titleLabel.text = item.title
        likeView.updateContent(content: "0")
        commentsView.updateContent(content: "0")
        timeView.updateContent(content: "0")
    }
}


//MARK: - configure
extension PostCollectionViewCell: BaseViewProtocol {
    
    func configureHierarchy() {
        
        contentView.addSubview(profileImageView)
        contentView.addSubview(nicknameLabel)
        contentView.addSubview(titleLabel)
        contentView.addSubview(likeView)
        contentView.addSubview(timeView)
        contentView.addSubview(commentsView)
    }
    
    func configureUI() {
        
        profileImageView.backgroundColor = .gray
        
        likeView.configureIcon(icon: .like)
        commentsView.configureIcon(icon: .comments)
        timeView.configureIcon(icon: .time)

        contentView.layer.cornerRadius = 8
        contentView.layer.borderWidth = 1
    }

    func configureLayout() {
        
            profileImageView.snp.makeConstraints { make in
                make.top.equalTo(contentView.snp.top).offset(16)
                make.leading.equalTo(contentView.snp.leading).offset(16)
                make.width.height.equalTo(32)
            }
            
            nicknameLabel.snp.makeConstraints { make in
                make.centerY.equalTo(profileImageView.snp.centerY)
                make.leading.equalTo(profileImageView.snp.trailing).offset(8)
                make.width.equalTo(contentView.snp.width).multipliedBy(0.6)
            }
            
            timeView.snp.makeConstraints { make in
                make.centerY.equalTo(profileImageView.snp.centerY)
                make.leading.equalTo(nicknameLabel.snp.trailing).offset(8)
                make.trailing.equalTo(contentView.snp.trailing).inset(16)
            }
            
            titleLabel.snp.makeConstraints { make in
                make.top.equalTo(profileImageView.snp.bottom).offset(8)
                make.leading.equalTo(contentView.snp.leading).offset(16)
                make.trailing.equalTo(contentView.snp.trailing).inset(16)
            }
            
            likeView.snp.makeConstraints { make in
                make.top.equalTo(titleLabel.snp.bottom).offset(16)
                make.leading.equalTo(contentView.snp.leading).offset(16)
                make.bottom.equalTo(contentView.snp.bottom).inset(16)
            }
            
            commentsView.snp.makeConstraints { make in
                make.top.equalTo(titleLabel.snp.bottom).offset(16)
                make.leading.equalTo(likeView.snp.trailing).offset(16)
                make.bottom.equalTo(contentView.snp.bottom).inset(16)
            }
        }
}
