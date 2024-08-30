//
//  NormalPostDetailCell.swift
//  Gourmet
//
//  Created by 최승범 on 8/30/24.
//

import UIKit
import SnapKit

final class NormalPostDetailCell: UITableViewCell {
    
    private let profileImageView = UIImageView()
    private let nicknameLabel = UILabel()
    private let titleLabel = UILabel()
    private let contentsLabel = UILabel()
    private let contentImageView = UIImageView()
    private let likeView = IconLabelView()
    private let timeView = IconLabelView()
    private let commentsView = IconLabelView()
    
    private let dateManager = DateManager.shared
    
    
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

extension NormalPostDetailCell {
    
    func updateContent(item: PostDTO) {
        
        nicknameLabel.text = item.creator.nick
        titleLabel.text = item.title
        contentsLabel.text = item.content
        likeView.updateContent(content: "\(item.likes.count)")
        commentsView.updateContent(content: "\(item.comments.count)")
        
        if let date = dateManager.stringToDate(value: item.createdAt) {
            timeView.updateContent(content: dateManager.dateToString(date: date))
        }
    }
}


//MARK: - configure
extension NormalPostDetailCell: BaseViewProtocol {
    
    func configureHierarchy() {
        
        contentView.addSubview(profileImageView)
        contentView.addSubview(nicknameLabel)
        contentView.addSubview(titleLabel)
        contentView.addSubview(contentsLabel)
        contentView.addSubview(contentImageView)
        contentView.addSubview(likeView)
        contentView.addSubview(timeView)
        contentView.addSubview(commentsView)
    }
    
    func configureUI() {
        
        profileImageView.image = UIImage(systemName: "person.fill")
        profileImageView.tintColor = .gray.withAlphaComponent(0.8)
        
        nicknameLabel.font = .systemFont(ofSize: 15,
                                         weight: .bold)
        titleLabel.font = .systemFont(ofSize: 16,
                                      weight: .bold)
        contentsLabel.font = .systemFont(ofSize: 14,
                                         weight: .medium)
        
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
            make.width.equalTo(contentView.snp.width).multipliedBy(0.5)
        }
        
        timeView.snp.makeConstraints { make in
            make.centerY.equalTo(profileImageView.snp.centerY)
            make.leading.equalTo(nicknameLabel.snp.trailing).offset(8)
            make.trailing.equalTo(contentView.snp.trailing).inset(16)
        }
        
        titleLabel.snp.makeConstraints { make in
            make.top.equalTo(profileImageView.snp.bottom).offset(8)
            make.directionalHorizontalEdges.equalTo(contentView.snp.directionalHorizontalEdges).inset(16)
        }
        
        contentsLabel.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom).offset(8)
            make.directionalHorizontalEdges.equalTo(contentView.snp.directionalHorizontalEdges).inset(16)
        }
        
//        contentImageView.snp.makeConstraints { make in
//            make.top.equalTo(contentsLabel.snp.bottom).offset(8)
//            make.directionalHorizontalEdges.equalTo(contentView.snp.directionalHorizontalEdges).inset(16)
//        }
        
        likeView.snp.makeConstraints { make in
            make.top.equalTo(contentsLabel.snp.bottom).offset(8)
            make.leading.equalTo(contentView.snp.leading).offset(16)
            make.bottom.equalTo(contentView.snp.bottom).inset(8)
        }
        
        commentsView.snp.makeConstraints { make in
            make.top.equalTo(contentsLabel.snp.bottom).offset(8)
            make.leading.equalTo(likeView.snp.trailing).offset(16)
            make.bottom.equalTo(contentView.snp.bottom).inset(8)
        }
    }
}

