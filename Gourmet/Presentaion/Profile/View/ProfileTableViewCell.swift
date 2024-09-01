//
//  ProfileTableViewCell.swift
//  Gourmet
//
//  Created by 최승범 on 8/31/24.
//

import UIKit
import SnapKit

final class ProfileTableViewCell: UITableViewCell {
    
    private let profileImageView = UIImageView()
    private let nicknameLabel = UILabel()
    private let pushImageView = UIImageView()
   
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
       configureView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension ProfileTableViewCell {
    
    func updateContent(item: UserDTO) {
       
        nicknameLabel.text = item.nick
    }
}

//MARK: - Configuration

extension ProfileTableViewCell: BaseViewProtocol {
    
    func configureHierarchy() {
        
        contentView.addSubview(profileImageView)
        contentView.addSubview(nicknameLabel)
        contentView.addSubview(pushImageView)
    }
    
    func configureUI() {
        
        profileImageView.layer.cornerRadius = 8
        profileImageView.image = UIImage(systemName: "person.fill")
        profileImageView.tintColor = .gray.withAlphaComponent(0.8)
        nicknameLabel.font = .systemFont(ofSize: 16, weight: .bold)
    }
    
    func configureLayout() {
       
        profileImageView.snp.makeConstraints { make in
            make.directionalVerticalEdges.equalToSuperview().inset(20)
            make.leading.equalToSuperview().offset(20)
            make.width.equalTo(profileImageView.snp.height)
        }
        
        nicknameLabel.snp.makeConstraints { make in
            make.leading.equalTo(profileImageView.snp.trailing).offset(16)
            make.top.equalTo(profileImageView.snp.top)
            make.bottom.equalTo(profileImageView.snp.bottom)
        }
        
        pushImageView.snp.makeConstraints { make in
            make.trailing.equalToSuperview().inset(20)
            make.centerY.equalToSuperview()
            make.size.equalTo(20)
        }
    }
    
}
