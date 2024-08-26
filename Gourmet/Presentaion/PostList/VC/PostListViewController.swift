//
//  PostListViewController.swift
//  Gourmet
//
//  Created by 최승범 on 8/24/24.
//

import UIKit
import RxSwift
import RxCocoa
import SnapKit

final class PostListViewController: UIViewController {
    
    private lazy var categoryCollectionView = UICollectionView(frame: .zero,
                                                       collectionViewLayout: categoryCreateLayout())
    private lazy var recipeCollectionView = UICollectionView(frame: .zero,
                                                       collectionViewLayout: recipeListCreateLayout())
    private let viewModel = PostViewModel(networkManager: NetworkManager.shared)
    private let disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureView()
        bindOutput()
    }
    
}

//MARK: - Logic
extension PostListViewController {
    
    private func bindOutput() {
        
        let input = PostViewModel.Input(reload: Observable.just(()))
        let output = viewModel.transform(input)
        
        output.items
            .bind(to: recipeCollectionView.rx.items(cellIdentifier: RecipeListCell.identifier,
                                              cellType: RecipeListCell.self)) { row, item, cell in
                cell.updateContent(item: item)
            }
            .disposed(by: disposeBag)
        
        output.category
            .bind(to: categoryCollectionView.rx.items(cellIdentifier: CategoryCell.identifier,
                                              cellType: CategoryCell.self)) { row, item, cell in
                cell.updateContent(item: item)
            }
            .disposed(by: disposeBag)
        
        output.needReLogin
            .bind(with: self) { owner, value in
                if value {
                    owner.resetViewController(vc: LoginViewController())
                }
            }
            .disposed(by: disposeBag)
    }
    
}

// MARK: - Configuration
extension PostListViewController: BaseViewProtocol {
    
    func configureHierarchy() {
        
        view.addSubview(categoryCollectionView)
        view.addSubview(recipeCollectionView)
    }
    
    func configureUI() {
        
        categoryCollectionView.register(CategoryCell.self,
                                forCellWithReuseIdentifier: CategoryCell.identifier)
        recipeCollectionView.register(RecipeListCell.self,
                                forCellWithReuseIdentifier: RecipeListCell.identifier)
    }
    
    func configureLayout() {
        
        view.backgroundColor = .systemBackground
        
        categoryCollectionView.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide)
            make.directionalHorizontalEdges.equalTo(view.safeAreaLayoutGuide)
            make.height.equalTo(44)
        }
        
        recipeCollectionView.snp.makeConstraints { make in
            make.top.equalTo(categoryCollectionView.snp.bottom)
            make.directionalHorizontalEdges.equalTo(view.safeAreaLayoutGuide)
            make.bottom.equalTo(view.safeAreaLayoutGuide)
        }
    }
    
    private func categoryCreateLayout() -> UICollectionViewLayout {
        
        let itemSize = NSCollectionLayoutSize(widthDimension: .estimated(60),
                                              heightDimension: .fractionalHeight(1.0))
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        
        
        let groupSize = NSCollectionLayoutSize(widthDimension: .estimated(60),
                                               heightDimension: .absolute(44))
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize,
                                                       subitems: [item])
        
        group.contentInsets = NSDirectionalEdgeInsets(top: 0,
                                                        leading: 0,
                                                        bottom: 16,
                                                        trailing: 0)
        
        let section = NSCollectionLayoutSection(group: group)
        section.orthogonalScrollingBehavior = .continuous
        section.interGroupSpacing = 8
        
        section.contentInsets = NSDirectionalEdgeInsets(top: 0,
                                                        leading: 16,
                                                        bottom: 0,
                                                        trailing: 16)
        
        let layout = UICollectionViewCompositionalLayout(section: section)
        
        return layout
    }
    
    private func recipeListCreateLayout() -> UICollectionViewLayout {
        
        let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0),
                                              heightDimension: .fractionalHeight(1.0))
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        
        
        let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0),
                                               heightDimension: .fractionalHeight(0.3))
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize,
                                                       subitems: [item])
        
        group.contentInsets = NSDirectionalEdgeInsets(top: 0,
                                                      leading: 0,
                                                      bottom: 16,
                                                      trailing: 0)
        
        let section = NSCollectionLayoutSection(group: group)
        
        section.contentInsets = NSDirectionalEdgeInsets(top: 0,
                                                        leading: 16,
                                                        bottom: 16,
                                                        trailing: 16)
        
        let layout = UICollectionViewCompositionalLayout(section: section)
        
        return layout
    }
    
}

