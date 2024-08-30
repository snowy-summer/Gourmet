//
//  HeaderView.swift
//  Gourmet
//
//  Created by 최승범 on 8/30/24.
//

import UIKit
import SnapKit

final class HeaderView: UIView {
    
    private let titleLabel = UILabel()
    private let iconView = UIView()
    private let iconImageView = UIImageView()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        configureView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
  
    
    func configureContent(type: EditRecipeSection) {
        
        titleLabel.text = type.headerTitle
        iconImageView.image = UIImage(systemName: type.iconName)
        iconView.backgroundColor = type.iconColor
    }
}
 
extension HeaderView: BaseViewProtocol {
    
    func configureHierarchy() {
        
        addSubview(titleLabel)
        addSubview(iconView)
        iconView.addSubview(iconImageView)
    }
    
    func configureUI() {
        
        titleLabel.font = .systemFont(ofSize: 17,
                                      weight: .semibold)
        
        iconView.layer.cornerRadius = 8
        iconView.backgroundColor = .systemBackground
        iconImageView.tintColor = .systemBackground
    }
    
    func configureLayout() {
        
        iconView.snp.makeConstraints { make in
            make.leading.equalTo(self.snp.leading).offset(8)
            make.verticalEdges.equalTo(self.snp.verticalEdges).inset(8)
            make.width.equalTo(iconView.snp.height)
        }
        
        iconImageView.snp.makeConstraints { make in
            make.directionalEdges.equalToSuperview().inset(4)
        }
        
        titleLabel.snp.makeConstraints { make in
            make.leading.equalTo(iconView.snp.trailing).offset(8)
            make.verticalEdges.equalToSuperview()
            make.trailing.equalTo(self.snp.trailing).inset(8)
        }
    }
}
