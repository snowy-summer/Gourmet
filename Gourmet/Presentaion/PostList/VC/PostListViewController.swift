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
    
    private lazy var collectionView = UICollectionView(frame: .zero,
                                                       collectionViewLayout: createLayout())
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
            .bind(to: collectionView.rx.items(cellIdentifier: NormalPostCell.identifier,
                                              cellType: NormalPostCell.self)) { row, item, cell in
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
        view.addSubview(collectionView)
    }
    
    func configureUI() {
        collectionView.register(NormalPostCell.self,
                                forCellWithReuseIdentifier: NormalPostCell.identifier)
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

