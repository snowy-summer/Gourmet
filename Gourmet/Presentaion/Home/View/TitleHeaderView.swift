//
//  TitleHeaderView.swift
//  Gourmet
//
//  Created by 최승범 on 8/20/24.
//

import UIKit
import SnapKit

final class TitleHeaderView: UICollectionReusableView {
    private let titleLabel = UILabel()

    override init(frame: CGRect) {
        super.init(frame: frame)
        
        configureView()
    }
    
    required init?(coder: NSCoder) {
        fatalError()
    }
    
    func updateText(title: String) {
        
        titleLabel.text = title
    }
}

//MARK: - Configuration
extension TitleHeaderView: BaseViewProtocol {
    
    func configureHierarchy() {
        
        addSubview(titleLabel)
    }
    
    func configureUI() {
        
        titleLabel.font = .systemFont(ofSize: 24, weight: .bold)
    }
    
    func configureLayout() {
        
        titleLabel.snp.makeConstraints { make in
            make.verticalEdges.leading.equalToSuperview()
        }
    }
}
