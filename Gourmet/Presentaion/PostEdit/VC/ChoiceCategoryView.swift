//
//  ChoiceCategoryView.swift
//  Gourmet
//
//  Created by 최승범 on 8/22/24.
//

import UIKit
import SnapKit

protocol ChoiceCategoryViewDelegate: AnyObject {
    func pushEditRecipeView()
    func pushEditNormalView()
}

final class ChoiceCategoryView: UIViewController {
    
    private let normalPostButton = UIButton()
    private let recipePostButton = UIButton()
    
    weak var delgate: ChoiceCategoryViewDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureView()
    }
}

extension ChoiceCategoryView {
    
    @objc private func pushEditRecipeView() {
        dismiss(animated: true) { [weak self] in
            self?.delgate?.pushEditRecipeView()
        }
    }
    
    @objc private func pushEditNormalPostView() {
        dismiss(animated: true) { [weak self] in
            self?.delgate?.pushEditNormalView()
        }
    }
    
    
}

extension ChoiceCategoryView: BaseViewProtocol {
    
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
