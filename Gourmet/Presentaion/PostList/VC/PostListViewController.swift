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
    private var categoryDataSource: UICollectionViewDiffableDataSource<PostListSection, Category>!
    private var recipeDataSource: UICollectionViewDiffableDataSource<PostListSection, PostDTO>!
    private let viewModel = PostViewModel(networkManager: NetworkManager.shared)
    private let disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureView()
        configureDataSource()
        bindOutput()
        viewModel.apply(.viewDidLoad)
    }
    
}

//MARK: - Logic
extension PostListViewController {
    
    private func bindOutput() {
        
        viewModel.output
            .bind(with: self) { owner, output in
                
                switch output {
                case .noValue:
                    return
                    
                case .reloadCollectionView(let categorys, let recipeList):
                    owner.updateSnapshot(categorys: categorys, recipeList: recipeList)
                    
                case .needLogin:
                    owner.resetViewController(vc: LoginViewController())
                    
                case .showDetailView(let recipe):
                    owner.navigationController?.pushViewController(PostDetailViewController(recipe: recipe),
                                                                   animated: true)
                }
                
            }.disposed(by: disposeBag)
    
    }
    
}

//MARK: - CollectionView
extension PostListViewController: UICollectionViewDelegate {
    
    typealias registerationCategory = UICollectionView.CellRegistration<CategoryCell, Category>
    typealias registerationRecipe = UICollectionView.CellRegistration<RecipeListCell, PostDTO>
    
    
    //MARK: - Delegate Method
    func collectionView(_ collectionView: UICollectionView,
                        didSelectItemAt indexPath: IndexPath) {
        
        if collectionView == categoryCollectionView {
            viewModel.apply(.selectCategory(indexPath.item))
        } else {
            viewModel.apply(.selectRecipe(indexPath.item))
        }
    }

    
    //MARK: - CollectoinView Configuraion
    private func registCategoryCell() -> registerationCategory {
        
        let cellRegistration = registerationCategory { cell, indexPath, itemIdentifier in
        
        }
        
        return cellRegistration
    }
    
    private func registRecipeCell() -> registerationRecipe {
        
        let cellRegistration = registerationRecipe { cell, indexPath, itemIdentifier in
            
        }
        
        return cellRegistration
    }
    
    private func configureDataSource() {
        
        let categoryRegistraion = registCategoryCell()
        let recipeRegistration = registRecipeCell()
        
        categoryDataSource = UICollectionViewDiffableDataSource(collectionView: categoryCollectionView,
                                                        cellProvider: { collectionView, indexPath, itemIdentifier in
            
            let cell = collectionView.dequeueConfiguredReusableCell(using: categoryRegistraion,
                                                                    for: indexPath,
                                                                    item: itemIdentifier)
            cell.updateContent(item: itemIdentifier)
            return cell
            

            
        })
        
        recipeDataSource = UICollectionViewDiffableDataSource(collectionView: recipeCollectionView,
                                                        cellProvider: { collectionView, indexPath, itemIdentifier in
            
            let cell = collectionView.dequeueConfiguredReusableCell(using: recipeRegistration,
                                                                    for: indexPath,
                                                                    item: itemIdentifier)
            cell.updateContent(item: itemIdentifier)
            return cell
            

            
        })
        
    }
    
    private func updateSnapshot(categorys: [Category],
                                recipeList: [PostDTO]) {
        
        var categorySnapshot = NSDiffableDataSourceSnapshot<PostListSection,Category>()
        categorySnapshot.appendSections([.category])
        categorySnapshot.appendItems(categorys,
                             toSection: .category)
        
        categoryDataSource.apply(categorySnapshot)
        
        var recipeListSnapshot = NSDiffableDataSourceSnapshot<PostListSection,PostDTO>()
        recipeListSnapshot.appendSections([.recipe])
        recipeListSnapshot.appendItems(recipeList,
                             toSection: .recipe)
        
        recipeDataSource.apply(recipeListSnapshot)
    }
    
}

// MARK: - Configuration
extension PostListViewController: BaseViewProtocol {
    
    func configureNavigationBar() {
        
        navigationItem.title = "Recipe"
    }
    
    func configureHierarchy() {
        
        view.addSubview(categoryCollectionView)
        view.addSubview(recipeCollectionView)
    }
    
    func configureUI() {
        
        categoryCollectionView.register(CategoryCell.self,
                                forCellWithReuseIdentifier: CategoryCell.identifier)
        recipeCollectionView.register(RecipeListCell.self,
                                forCellWithReuseIdentifier: RecipeListCell.identifier)
        
        categoryCollectionView.delegate = self
        recipeCollectionView.delegate = self
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

private enum PostListSection: CaseIterable {
    case category
    case recipe
}
