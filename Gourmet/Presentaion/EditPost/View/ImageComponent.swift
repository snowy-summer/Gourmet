//
//  ImageComponent.swift
//  Gourmet
//
//  Created by 최승범 on 8/23/24.
//

import UIKit
import SnapKit

final class ImageComponent: UIView {
    
    let imageView = UIImageView()
    private let removeImageView = UIImageView()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        configureView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

extension ImageComponent {
    
    func updateContent(image: UIImage?) {
        
        imageView.image = image
    }
}

//MARK: - Configuration
extension ImageComponent: BaseViewProtocol {
    
    func configureHierarchy() {
        
        addSubview(imageView)
        addSubview(removeImageView)
    }
    
    func configureUI() {
        
        imageView.layer.cornerRadius = 8
        imageView.clipsToBounds = true
        removeImageView.image = UIImage(systemName: "minus.circle.fill")
        removeImageView.tintColor = .red
    }
    
    func configureLayout() {
        
        removeImageView.snp.makeConstraints { make in
            make.top.trailing.equalToSuperview()
            make.width.equalToSuperview().multipliedBy(0.2)
            make.height.equalToSuperview().multipliedBy(0.2)
        }
        
        imageView.snp.makeConstraints { make in
            make.top.equalTo(removeImageView.snp.centerY)
            make.trailing.equalTo(removeImageView.snp.centerX)
            make.leading.equalToSuperview()
            make.bottom.equalToSuperview()
        }
    }
    
    
}
