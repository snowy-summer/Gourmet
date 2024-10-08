//
//  NormalPostListViewController.swift
//  Gourmet
//
//  Created by 최승범 on 8/18/24.
//

import UIKit
import RxSwift
import RxCocoa
import SnapKit

final class NormalPostListViewController: UIViewController {
    
    private lazy var collectionView = UICollectionView(frame: .zero,
                                                       collectionViewLayout: createLayout())
    private var dataSource: UICollectionViewDiffableDataSource<NormalPostSection,PostDTO>!
    private let viewModel = NormalViewModel(networkManager: NetworkManager.shared)
    private let disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureView()
        configureDataSource()
        bindOutput()
        viewModel.apply(.refreshData)
        
    }
    
}

//MARK: - Logic
extension NormalPostListViewController {
    
    private func bindOutput() {
        
        viewModel.output.bind(with: self) { owner, output in
            
            switch output {
            case .noValue:
                return
                
            case .reloadView(let item):
                owner.updateSnapshot(postList: item)
                
            case .needReLogin:
                owner.resetViewController(vc: LoginViewController())
                
            case .showDetailView(let post):
                owner.navigationController?.pushViewController(NormalPostDetailViewController(postId: post.postId),
                                                               animated: true)
            }
        }
        .disposed(by: disposeBag)
        
    }
    
}

//MARK: - CollectionView
extension NormalPostListViewController: UICollectionViewDelegate {
    
    typealias postRegisteration = UICollectionView.CellRegistration<NormalPostCell, PostDTO>
    
    func collectionView(_ collectionView: UICollectionView,
                        didSelectItemAt indexPath: IndexPath) {
        viewModel.apply(.selectDetailView(indexPath.item))
    }
    
    //MARK: - CollectoinView Configuraion
    private func registPostCell() -> postRegisteration {
        
        let cellRegistration = postRegisteration { cell, indexPath, itemIdentifier in
            
        }
        
        return cellRegistration
    }
    
    private func configureDataSource() {
        
        let postRegistraion = registPostCell()
        
        dataSource = UICollectionViewDiffableDataSource(collectionView: collectionView,
                                                        cellProvider: { collectionView, indexPath, itemIdentifier in
            
            let cell = collectionView.dequeueConfiguredReusableCell(using: postRegistraion,
                                                                    for: indexPath,
                                                                    item: itemIdentifier)
            cell.updateContent(item: itemIdentifier)
            return cell
        })
        
        
    }
    
    private func updateSnapshot(postList: [PostDTO]) {
        
        var normalPostSnapshot = NSDiffableDataSourceSnapshot<NormalPostSection,PostDTO>()
        normalPostSnapshot.appendSections(NormalPostSection.allCases)
        normalPostSnapshot.appendItems(postList,
                                       toSection: .post)
        
        dataSource.apply(normalPostSnapshot)
    }
    
}

extension NormalPostListViewController: UICollectionViewDataSourcePrefetching {
    
    func collectionView(_ collectionView: UICollectionView,
                        prefetchItemsAt indexPaths: [IndexPath]) {
        
        guard let lastIndexPath = indexPaths.max() else { return }
        
        
        let itemCount = viewModel.normalPostList.count
        
        
        if lastIndexPath.item >= itemCount - 3 {
            viewModel.apply(.updateNextData)
        }
        
    }

}

// MARK: - Configuration
extension NormalPostListViewController: BaseViewProtocol {
    
    func configureHierarchy() {
        view.addSubview(collectionView)
    }
    
    func configureUI() {
        
        collectionView.delegate = self
        collectionView.prefetchDataSource = self
        collectionView.register(NormalPostCell.self,
                                forCellWithReuseIdentifier: NormalPostCell.identifier)
        configureRefreshControl()
    }
    
    func configureRefreshControl () {
        
        let refreshControl = UIRefreshControl()
        collectionView.refreshControl = refreshControl
        refreshControl.rx.controlEvent(.valueChanged)
            .subscribe(with: self) { owner, _ in
                owner.viewModel.apply(.refreshData)
                refreshControl.endRefreshing()
            }
            .disposed(by: disposeBag)
    }
    
    func configureLayout() {
        
        view.backgroundColor = .systemBackground
        
        collectionView.snp.makeConstraints { make in
            make.directionalEdges.equalTo(view.safeAreaLayoutGuide)
        }
    }
    
    private func createLayout() -> UICollectionViewLayout {
        
        let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0),
                                              heightDimension: .fractionalHeight(1.0))
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        
        
        let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0),
                                               heightDimension: .fractionalHeight(0.2))
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

private enum NormalPostSection: Int, CaseIterable {
    case post
}
