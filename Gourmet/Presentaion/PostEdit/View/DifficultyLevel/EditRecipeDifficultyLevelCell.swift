//
//  EditRecipeDifficultyLevelCell.swift
//  Gourmet
//
//  Created by 최승범 on 8/28/24.
//

import UIKit
import SnapKit

protocol EditRecipeDifficultyLevelCellDelegate: AnyObject {
    func changeLevel(_ value: String)
}

final class EditRecipeDifficultyLevelCell: UICollectionViewCell {
    
    private let iconAndTitleView = HeaderView()
    private let contentLabel = UILabel()
    private let menuButton = UIButton()
    
    weak var delegate: EditRecipeDifficultyLevelCellDelegate?
    
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
 
        contentLabel.text = item
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
            delegate?.changeLevel("쉬움")
        }
        
        let middle = UIAction(title: "보통") { [weak self] _ in
            guard let self = self else { return }
            delegate?.changeLevel("보통")
        }
        
        let high = UIAction(title: "어려움") { [weak self] _ in
            guard let self = self else { return }
            delegate?.changeLevel("어려움")
        }
        
        let items = [
           low,
           middle,
           high
        ]
    
        return items
    }
    
}

