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
    private let viewModel = NormalViewModel()
    private let disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureView()
        bindOutput()
    }
    
    private func bindOutput() {
        
        let input = NormalViewModel.Input(reload: Observable.just(()))
        let output = viewModel.transform(input)
        
        output.items
            .bind(to: collectionView.rx.items(cellIdentifier: PostCollectionViewCell.identifier,
                                              cellType: PostCollectionViewCell.self)) { row, item, cell in
                cell.updateContent(item: item)
            }
            .disposed(by: disposeBag)
    }
    
    
}

// MARK: - Configuration
extension NormalPostListViewController: BaseViewProtocol {
    
    func configureHierarchy() {
        view.addSubview(collectionView)
    }
    
    func configureUI() {
        collectionView.register(PostCollectionViewCell.self,
                                forCellWithReuseIdentifier: PostCollectionViewCell.identifier)
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
