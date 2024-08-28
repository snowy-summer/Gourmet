//
//  EditRecipeDifficultyLevelCell.swift
//  Gourmet
//
//  Created by 최승범 on 8/28/24.
//

import UIKit
import SnapKit

final class EditRecipeDifficultyLevelCell: UICollectionViewCell {
    
    private let iconAndTitleView = HeaderView()
    private let contentLabel = UILabel()
    private let menuButton = UIButton()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        configureView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

extension EditRecipeDifficultyLevelCell {
    
    func updateContent(item: String) {
        
//        if item.isAddCell {
//            addImageView.isHidden = false
//            nameLabel.isHidden = true
//            valueLabel.isHidden = true
//            return
//        }
//        
//        nameLabel.text = item.name
//        valueLabel.text = item.value
    }
}

//MARK: - Configuraion
extension EditRecipeDifficultyLevelCell: BaseViewProtocol {
    
    func configureHierarchy() {
        
        contentView.addSubview(iconAndTitleView)
        contentView.addSubview(contentLabel)
        contentView.addSubview(menuButton)
    }
    
    func configureUI() {
        
        menuButton.setImage( UIImage(systemName: "chevron.up.chevron.down"),
                             for: .normal)
        menuButton.tintColor = .lightGray
        menuButton.menu = UIMenu(children: configureMenu())
        menuButton.showsMenuAsPrimaryAction = true
        
        iconAndTitleView.configureContent(type: .difficulty)
        
        contentLabel.textAlignment = .right
        contentLabel.font = .systemFont(ofSize: 14, weight: .light)
        contentLabel.text = EditRecipeSection.difficulty.defaultValue
    }
    
    func configureLayout() {
        
        iconAndTitleView.snp.makeConstraints { make in
            make.leading.equalTo(contentView.snp.leading).inset(8)
            make.verticalEdges.equalTo(contentView.snp.verticalEdges).inset(8)
        }
        
        contentLabel.snp.makeConstraints { make in
            make.leading.equalTo(iconAndTitleView.snp.trailing)
            make.centerY.equalTo(iconAndTitleView.snp.centerY)
        }
        
        menuButton.snp.makeConstraints { make in
            make.leading.equalTo(contentLabel.snp.trailing)
            make.trailing.equalTo(contentView.snp.trailing).inset(16)
            make.verticalEdges.equalTo(contentView.snp.verticalEdges).inset(8)
            make.width.equalTo(contentView.snp.width).multipliedBy(0.1)
        }
    
    }
    
    private func configureMenu() -> [UIAction] {
        

        let low = UIAction(title: "쉬움") { [weak self] _ in
            guard let self = self else { return }
//            viewModel?.applyInput(.selectPriority(1))
        }
        
        let middle = UIAction(title: "보통") { [weak self] _ in
            guard let self = self else { return }
//            viewModel?.applyInput(.selectPriority(2))
        }
        
        let high = UIAction(title: "어려움") { [weak self] _ in
            guard let self = self else { return }
//            viewModel?.applyInput(.selectPriority(3))
        }
        
        let items = [
           low,
           middle,
           high
        ]
    
        return items
    }
    
}


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
