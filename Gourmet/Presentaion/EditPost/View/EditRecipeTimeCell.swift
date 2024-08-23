//
//  EditRecipeTimeCell.swift
//  Gourmet
//
//  Created by 최승범 on 8/22/24.
//

import UIKit
import SnapKit

final class EditRecipeTimeCell: UICollectionViewCell {
    
    private let timeLabel = UILabel()
    private let addImageView = UIImageView()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        configureView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        
        addImageView.isHidden = true
    }
    
}

extension EditRecipeTimeCell {
    
    func updateContent(item: String) {
        
        addImageView.isHidden = item.isEmpty ? false : true
        timeLabel.text = item
    }
}

//MARK: - Configuraion
extension EditRecipeTimeCell: BaseViewProtocol {
    
    func configureHierarchy() {
        
        contentView.addSubview(timeLabel)
        contentView.addSubview(addImageView)
    }
    
    func configureUI() {

        contentView.backgroundColor = .lightGray
        contentView.layer.cornerRadius = 8
        contentView.clipsToBounds = true
        
        addImageView.image = UIImage(systemName: "plus")
        addImageView.tintColor = .main
        addImageView.isHidden = true
    }
    
    func configureLayout() {
    
        timeLabel.snp.makeConstraints { make in
            make.directionalVerticalEdges.equalTo(contentView.snp.directionalVerticalEdges)
            make.directionalHorizontalEdges.equalTo(contentView.snp.directionalHorizontalEdges).inset(8)
        }
        
        addImageView.snp.makeConstraints { make in
            make.size.equalTo(20)
            make.center.equalTo(contentView.snp.center)
        }
    }
    
}

