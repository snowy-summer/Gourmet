//
//  IconAndTitleVIew.swift
//  Gourmet
//
//  Created by 최승범 on 8/28/24.
//

import UIKit
import SnapKit

final class IconAndTitleView: UIView {
    
    private let titleLabel = UILabel()
    private let iconView = UIView()
    private let iconImageView = UIImageView()
    private let contentLabel = UILabel()

    override init(frame: CGRect) {
        super.init(frame: frame)
        
        configureHierarchy()
        configureUI()
        configureLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func configureHierarchy() {
        
        addSubview(titleLabel)
        addSubview(contentLabel)
        addSubview(iconView)
        iconView.addSubview(iconImageView)
    }
    
    private func configureUI() {
        
        titleLabel.font = .systemFont(ofSize: 17,
                                      weight: .semibold)
        
        iconView.layer.cornerRadius = 8
        iconView.backgroundColor = .orange
    }
    
    private func configureLayout() {
        
        iconView.snp.makeConstraints { make in
            make.leading.equalTo(self.snp.leading).offset(8)
            make.verticalEdges.equalTo(self.snp.verticalEdges).inset(8)
            make.size.equalTo(60)
        }
        
        iconImageView.snp.makeConstraints { make in
            make.directionalEdges.equalToSuperview().inset(4)
        }
        
        titleLabel.snp.makeConstraints { make in
            make.leading.equalTo(iconView.snp.trailing).offset(8)
            make.verticalEdges.equalToSuperview()
        }
        
        contentLabel.snp.makeConstraints { make in
            make.trailing.equalTo(self.snp.trailing).inset(20)
            make.verticalEdges.equalToSuperview()
        }
    }
    
    func updateContent(image: UIImage?,
                       name: String,
                       value: String) {
        
        titleLabel.text = name
        contentLabel.text = value
        iconImageView.image = image
        iconView.backgroundColor = .systemBackground
        
    }
}

