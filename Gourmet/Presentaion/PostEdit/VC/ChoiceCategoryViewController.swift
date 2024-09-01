//
//  ChoiceCategoryViewController.swift
//  Gourmet
//
//  Created by 최승범 on 8/22/24.
//

import UIKit
import SnapKit

final class ChoiceCategoryViewController: UIViewController {
    
    private let normalPostButton = UIButton()
    private let recipePostButton = UIButton()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureView()
    }
}

extension ChoiceCategoryViewController {
    
    @objc private func pushEditRecipeView() {
        navigationController?.pushViewController(EditRecipeViewController(),
                                                 animated: true)
    }
    
    @objc private func pushEditNormalPostView() {
        navigationController?.pushViewController(NormalPostEditViewController(),
                                                 animated: true)
    }
    
    
}

extension ChoiceCategoryViewController: BaseViewProtocol {
    
    func configureHierarchy() {
        
        view.addSubview(normalPostButton)
        view.addSubview(recipePostButton)
    }
    
    func configureUI() {
        
        view.backgroundColor = .systemBackground
        
        normalPostButton.layer.cornerRadius = 16
        normalPostButton.layer.borderWidth = 1
        
        recipePostButton.layer.cornerRadius = 16
        recipePostButton.layer.borderWidth = 1
        
        normalPostButton.setImage(UIImage(resource: .community), for: .normal)
        recipePostButton.setImage(UIImage(resource: .recipe), for: .normal)
    }
    
    func configureLayout() {
        
        normalPostButton.snp.makeConstraints { make in
            make.size.equalTo(100)
            make.centerX.equalTo(view.snp.centerX).offset(-55)
            make.centerY.equalTo(view.snp.centerY)
        }
        
        recipePostButton.snp.makeConstraints { make in
            make.size.equalTo(100)
            make.centerX.equalTo(view.snp.centerX).offset(55)
            make.centerY.equalTo(view.snp.centerY)
        }
    }
    
    func configureGestureAndButtonActions() {
        
        normalPostButton.addTarget(self,
                                   action: #selector(pushEditNormalPostView),
                                   for: .touchUpInside)
        
        recipePostButton.addTarget(self,
                                   action: #selector(pushEditRecipeView),
                                   for: .touchUpInside)
    }
    
}
