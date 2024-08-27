//
//  PostDetailViewController.swift
//  Gourmet
//
//  Created by 최승범 on 8/26/24.
//

import UIKit
import RxSwift
import RxCocoa
import SnapKit

final class PostDetailViewController: UIViewController {
    
    private lazy var collectionView = UICollectionView(frame: .zero,
                                                       collectionViewLayout: createLayout())
    private var dataSource: UICollectionViewDiffableDataSource<PostDetailSection, PostDetailViewModel.Item>!
    private let viewModel: PostDetailViewModel
    private let disposeBag = DisposeBag()
    
    init(recipe: PostDTO) {
        self.viewModel = PostDetailViewModel(recipe: recipe)
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureView()
        configureDataSource()
        bindOutput()
        viewModel.apply(.viewDidLoad)
    }
    
}

//MARK: - Logic
extension PostDetailViewController {
    
    private func bindOutput() {
        
        viewModel.output
            .bind(with: self) { owner, output in
                
                switch output {
                case .noValue:
                    return
                    
                case .reloadCollectionView(let recipe):
                    owner.updateSnapshot(recipe: recipe)
                    
                }
                
            }.disposed(by: disposeBag)
        
    }
    
}

//MARK: - CollectionView
extension PostDetailViewController {
    
    typealias imageTitleRegisteration = UICollectionView.CellRegistration<PostDetailImageCell, PostDTO>
    typealias ingredientRegisteration = UICollectionView.CellRegistration<PostDetailIngredientCell, RecipeIngredient>
    typealias recipeRegisteration = UICollectionView.CellRegistration<PostDetailRecipeStepCell, RecipeContent>
    
    
    //MARK: - CollectoinView Configuraion
    private func registImageTitleCell() -> imageTitleRegisteration {
        
        let cellRegistration = imageTitleRegisteration { cell, indexPath, itemIdentifier in
            
        }
        
        return cellRegistration
    }
    
    private func registIngredientCell() -> ingredientRegisteration {
        
        let cellRegistration = ingredientRegisteration { cell, indexPath, itemIdentifier in
            
        }
        
        return cellRegistration
    }
    
    private func registRecipeCell() -> recipeRegisteration {
        
        let cellRegistration = recipeRegisteration { cell, indexPath, itemIdentifier in
            
            cell.layer.cornerRadius = 8
            cell.clipsToBounds = true
        }
        
        return cellRegistration
    }
    
    private func configureDataSource() {
        
        let imageTitleRegistraion = registImageTitleCell()
        let ingredientRegistraion = registIngredientCell()
        let recipeRegistraion = registRecipeCell()
        
        dataSource = UICollectionViewDiffableDataSource(collectionView: collectionView,
                                                        cellProvider: { collectionView, indexPath, itemIdentifier in
            
            switch itemIdentifier {
            case .imageTitle(let recipe):
                let cell = collectionView.dequeueConfiguredReusableCell(using: imageTitleRegistraion,
                                                                        for: indexPath,
                                                                        item: recipe)
                cell.updateContent(item: recipe)
                return cell
                
            case .ingredient(let recipe):
                let cell = collectionView.dequeueConfiguredReusableCell(using: ingredientRegistraion,
                                                                        for: indexPath,
                                                                        item: recipe)
                cell.updateContent(item: recipe)
                return cell
                
            case .recipeContent(let recipe):
                let cell = collectionView.dequeueConfiguredReusableCell(using: recipeRegistraion,
                                                                        for: indexPath,
                                                                        item: recipe)
                cell.updateContent(item: recipe)
                
                return cell
            }
            
           
        })
        
        
    }
    
    private func updateSnapshot(recipe: PostDTO) {
        
        var recipeSnapshot = NSDiffableDataSourceSnapshot<PostDetailSection,PostDetailViewModel.Item>()
        recipeSnapshot.appendSections(PostDetailSection.allCases)
        recipeSnapshot.appendItems([.imageTitle(recipe)],
                                   toSection: .imageTitle)
        recipeSnapshot.appendItems(viewModel.ingredients,
                                   toSection: .ingredient)
        recipeSnapshot.appendItems(viewModel.recipeStep,
                                   toSection: .recipeStap)
        
        dataSource.apply(recipeSnapshot)
    }
    
}

// MARK: - Configuration
extension PostDetailViewController: BaseViewProtocol {
    
    func configureNavigationBar() {
        
        navigationItem.title = "Recipe"
    }
    
    func configureHierarchy() {
        
        view.addSubview(collectionView)
    }
    
    func configureUI() {
        
        collectionView.register(PostDetailImageCell.self,
                                forCellWithReuseIdentifier: PostDetailImageCell.identifier)
    }
    
    func configureLayout() {
        
        view.backgroundColor = .systemBackground
        
        collectionView.snp.makeConstraints { make in
            make.directionalEdges.equalTo(view.safeAreaLayoutGuide)
        }
    }
    
    private func createLayout() -> UICollectionViewLayout {
        
        return UICollectionViewCompositionalLayout { sectionIndex, layoutEnvironment -> NSCollectionLayoutSection? in
            
            let section = PostDetailSection(rawValue: sectionIndex)
            return section?.layout
        }
    }
    
}

private enum PostDetailSection: Int, CaseIterable {
    case imageTitle
    case ingredient
    case recipeStap
    
    var layout: NSCollectionLayoutSection {
        switch self {
        case .imageTitle:
            let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0),
                                                  heightDimension: .fractionalHeight(1.0))
            let item = NSCollectionLayoutItem(layoutSize: itemSize)
            
            
            let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0),
                                                   heightDimension: .fractionalHeight(0.6))
            let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize,
                                                           subitems: [item])
            
            group.contentInsets = NSDirectionalEdgeInsets(top: 0,
                                                          leading: 0,
                                                          bottom: 16,
                                                          trailing: 0)
            
            let section = NSCollectionLayoutSection(group: group)
            return section
            
        case .ingredient:
            let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0),
                                                  heightDimension: .fractionalHeight(1.0))
            let item = NSCollectionLayoutItem(layoutSize: itemSize)
            
            
            let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0),
                                                   heightDimension: .absolute(44))
            let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize,
                                                           subitems: [item])
            
            group.contentInsets = NSDirectionalEdgeInsets(top: 0,
                                                          leading: 0,
                                                          bottom: 8,
                                                          trailing: 0)
            
            let section = NSCollectionLayoutSection(group: group)
            section.contentInsets = NSDirectionalEdgeInsets(top: 0,
                                                            leading: 16,
                                                            bottom: 0,
                                                            trailing: 16)
            return section
            
        case .recipeStap:
            let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0),
                                                  heightDimension: .fractionalHeight(1.0))
            let item = NSCollectionLayoutItem(layoutSize: itemSize)
            
            
            let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(0.9),
                                                   heightDimension: .estimated(300))
            let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize,
                                                           subitems: [item])
            
            
            let section = NSCollectionLayoutSection(group: group)
            section.interGroupSpacing = 16
            section.contentInsets = NSDirectionalEdgeInsets(top: 0,
                                                            leading: 16,
                                                            bottom: 0,
                                                            trailing: 16)
            section.orthogonalScrollingBehavior = .paging
            return section
        }
    }
}
