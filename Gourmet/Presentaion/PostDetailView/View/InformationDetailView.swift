//
//  InformationDetailView.swift
//  Gourmet
//
//  Created by 최승범 on 8/26/24.
//

import UIKit
import SnapKit

final class InformationDetailView: UIView {
    
    private let iconImageView = UIImageView()
    private let nameLabel = UILabel()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        configureView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension InformationDetailView: BaseViewProtocol {
    
    func configureHierarchy() {
        
        addSubview(iconImageView)
        addSubview(nameLabel)
    }
    
    func configureUI() {
    
        iconImageView.image = UIImage(systemName: "star")
        
        nameLabel.text = "20 min"
        nameLabel.font = UIFont.systemFont(ofSize: 14)
        nameLabel.textAlignment = .center
    }
    
    func configureLayout() {

        nameLabel.snp.makeConstraints { make in
            make.directionalHorizontalEdges.equalTo(snp.directionalHorizontalEdges)
            make.bottom.equalToSuperview()
        }
        
        iconImageView.snp.makeConstraints { make in
            make.top.centerX.equalToSuperview()
            make.bottom.equalTo(nameLabel.snp.top).offset(-4)
            make.width.equalTo(iconImageView.snp.height)
        }
    }
}
