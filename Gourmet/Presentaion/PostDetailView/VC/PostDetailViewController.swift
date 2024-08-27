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
                                                       collectionViewLayout: recipeListCreateLayout())
    private var dataSource: UICollectionViewDiffableDataSource<PostDetailSection, PostDTO>!
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
    
    
    //MARK: - CollectoinView Configuraion
    private func registImageTitleCell() -> imageTitleRegisteration {
        
        let cellRegistration = imageTitleRegisteration { cell, indexPath, itemIdentifier in
        
        }
        
        return cellRegistration
    }
    
    private func configureDataSource() {
        
        let imageTitleRegistraion = registImageTitleCell()
        
       
        dataSource = UICollectionViewDiffableDataSource(collectionView: collectionView,
                                                        cellProvider: { collectionView, indexPath, itemIdentifier in
            
            let cell = collectionView.dequeueConfiguredReusableCell(using: imageTitleRegistraion,
                                                                    for: indexPath,
                                                                    item: itemIdentifier)
            cell.updateContent(item: itemIdentifier)
            return cell
            

            
        })
        
    }
    
    private func updateSnapshot(recipe: [PostDTO]) {
        
        var recipeSnapshot = NSDiffableDataSourceSnapshot<PostDetailSection,PostDTO>()
        recipeSnapshot.appendSections(PostDetailSection.allCases)
        recipeSnapshot.appendItems(recipe,
                                       toSection: .imageTitle)
        
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
    
    private func recipeListCreateLayout() -> UICollectionViewLayout {
        
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
        
        
        let layout = UICollectionViewCompositionalLayout(section: section)
        
        return layout
    }
    
}

private enum PostDetailSection: CaseIterable {
    case imageTitle
    case ingredient
    case recipeStap
}

