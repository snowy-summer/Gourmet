//
//  IconLabelView.swift
//  Gourmet
//
//  Created by 최승범 on 8/18/24.
//

import UIKit
import RxSwift
import RxCocoa
import SnapKit

final class IconLabelView: UIView {
    
    private let iconImageView = UIImageView()
    private let contentLabel = UILabel()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        configureView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

// MARK: - Method
extension IconLabelView {
    
    func updateContent(content: String) {
        contentLabel.text = content
    }
    
    func configureIcon(icon: IconConmponent) {
        
        iconImageView.image = UIImage(systemName: icon.iconName)
        iconImageView.tintColor = icon.color
    }
    
}

// MARK: - Configure
extension IconLabelView: BaseViewProtocol {
    
    func configureHierarchy() {
        
        addSubview(iconImageView)
        addSubview(contentLabel)
    }
    
    func configureUI() {
        
        contentLabel.font = .systemFont(ofSize: 14)
    }
    
    func configureLayout() {
        
        iconImageView.snp.makeConstraints { make in
            make.centerY.equalTo(self.snp.centerY)
            make.leading.equalTo(self)
            make.size.equalTo(18)
        }
        
        contentLabel.snp.makeConstraints { make in
            make.verticalEdges.equalTo(self)
            make.leading.equalTo(iconImageView.snp.trailing).offset(4)
            make.trailing.equalTo(self.snp.trailing)
        }
    }
    
    
}
