//
//  CommentTableViewCell.swift
//  Gourmet
//
//  Created by 최승범 on 8/30/24.
//

import UIKit
import SnapKit

final class CommentTableViewCell: UITableViewCell {
    
    private let profileImageView = UIImageView()
    private let nicknameLabel = UILabel()
    private let titleLabel = UILabel()
    private let contentsLabel = UILabel()
    
    override init(style: UITableViewCell.CellStyle,
                  reuseIdentifier: String?) {
        super.init(style: style,
                   reuseIdentifier: reuseIdentifier)
        
        configureView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

extension CommentTableViewCell {
    
    func updateContent(item: CommentDTO) {
        
        nicknameLabel.text = item.creator.nick
        titleLabel.text = item.content
    }
}


//MARK: - configure
extension CommentTableViewCell: BaseViewProtocol {
    
    func configureHierarchy() {
        
        contentView.addSubview(profileImageView)
        contentView.addSubview(nicknameLabel)
        contentView.addSubview(titleLabel)
    }

    func configureUI() {
        
        profileImageView.image = UIImage(systemName: "person.fill")
        profileImageView.tintColor = .gray.withAlphaComponent(0.8)
        
        nicknameLabel.font = .systemFont(ofSize: 16,
                                         weight: .bold)
        
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
                make.width.equalTo(contentView.snp.width).multipliedBy(0.5)
            }
            
            titleLabel.snp.makeConstraints { make in
                make.top.equalTo(profileImageView.snp.bottom).offset(8)
                make.leading.equalTo(contentView.snp.leading).offset(16)
                make.trailing.equalTo(contentView.snp.trailing).inset(16)
            }
        }
}

