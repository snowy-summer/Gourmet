//
//  ImageAndContentView.swift
//  Gourmet
//
//  Created by 최승범 on 8/28/24.
//

import UIKit
import SnapKit

final class ImageAndContentView: UIView {
    
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
    
}
 
extension ImageAndContentView: BaseViewProtocol {
    
    func configureHierarchy() {
        
        addSubview(titleLabel)
        addSubview(iconView)
        iconView.addSubview(iconImageView)
    }
    
    func configureUI() {
        
        titleLabel.font = .systemFont(ofSize: 17,
                                      weight: .semibold)
        titleLabel.numberOfLines = .zero
        
        iconView.layer.cornerRadius = 8
        iconView.clipsToBounds = true
        iconView.backgroundColor = .systemBackground
    }
    
    func configureLayout() {
        
        iconView.snp.makeConstraints { make in
            make.leading.equalTo(self.snp.leading).offset(8)
            make.verticalEdges.equalTo(self.snp.verticalEdges).inset(8)
            make.size.equalTo(60)
        }
        
        iconImageView.snp.makeConstraints { make in
            make.directionalEdges.equalToSuperview()
        }
        
        titleLabel.snp.makeConstraints { make in
            make.leading.equalTo(iconView.snp.trailing).offset(8)
            make.verticalEdges.equalToSuperview()
            make.trailing.equalTo(self.snp.trailing).inset(16)
        }
    }
    
    func updateContent(image: UIImage?,
                       content: String) {
        
        titleLabel.text = content
        iconImageView.image = image
    }
}

