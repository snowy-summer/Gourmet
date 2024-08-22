//
//  HomeViewController.swift
//  Gourmet
//
//  Created by 최승범 on 8/20/24.
//

import UIKit
import SnapKit
import RxSwift
import RxCocoa
import RxDataSources

final class HomeViewController: UIViewController {
    
    private lazy var collectionView = UICollectionView(frame: .zero,
                                                       collectionViewLayout: createLayout())
    private let viewModel = HomeViewModel(networkManager: NetworkManager.shared)
    private let disposeBag = DisposeBag()
    
    private var dataSource: RxCollectionViewSectionedReloadDataSource<HomeViewSectionModel>!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureView()
        configureDataSource()
        bindOutput()
        
    }
    
}

//MARK: - Logic
extension HomeViewController {
    
    private func bindOutput() {
        
        let input = HomeViewModel.Input(reload: Observable.just(()))
        let output = viewModel.transform(input)
        
        output.sections
            .bind(to: collectionView.rx.items(dataSource: dataSource))
            .disposed(by: disposeBag)
        
        output.needReLogin
            .bind(with: self) { owner, value in
                if value {
                    owner.resetViewController(vc: LoginViewController())
                }
            }
            .disposed(by: disposeBag)
    }
    
    private func configureDataSource() {
        
        dataSource = RxCollectionViewSectionedReloadDataSource<HomeViewSectionModel>(
            configureCell: { dataSource, collectionView, indexPath, item in
                
               guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: RecipeCollectionViewCell.identifier,
                                                                   for: indexPath) as? RecipeCollectionViewCell else { return RecipeCollectionViewCell() }
                cell.updateContent(item: item)
                return cell
            },
            configureSupplementaryView: { dataSource, collectionView, kind, indexPath in
                
                guard let header = collectionView.dequeueReusableSupplementaryView(ofKind: kind,
                                                                             withReuseIdentifier: TitleHeaderView.identifier,
                                                                                   for: indexPath) as? TitleHeaderView else { return TitleHeaderView() }
                let title = dataSource.sectionModels[indexPath.section].header
                header.updateText(title: title)
                return header
            }
        )
    }
}

// MARK: - Configuration
extension HomeViewController: BaseViewProtocol {
    
    func configureHierarchy() {
        view.addSubview(collectionView)
    }
    
    func configureUI() {
        
        collectionView.register(RecipeCollectionViewCell.self,
                                forCellWithReuseIdentifier: RecipeCollectionViewCell.identifier)
        collectionView.register(TitleHeaderView.self,
                                forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader,
                                withReuseIdentifier: TitleHeaderView.identifier)
    }
    
    func configureLayout() {
        
        view.backgroundColor = .systemBackground
        
        collectionView.snp.makeConstraints { make in
            make.directionalEdges.equalTo(view.safeAreaLayoutGuide)
        }
    }
    
    private func createLayout() -> UICollectionViewLayout {
        
        return UICollectionViewCompositionalLayout { sectionIndex, layoutEnvironment -> NSCollectionLayoutSection? in
            
            if sectionIndex == 0 {
                let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0),
                                                      heightDimension: .fractionalHeight(1.0))
                let item = NSCollectionLayoutItem(layoutSize: itemSize)
                
                
                let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(0.8),
                                                       heightDimension: .fractionalHeight(0.35))
                let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize,
                                                               subitems: [item])
                
                let section = NSCollectionLayoutSection(group: group)
                section.orthogonalScrollingBehavior = .continuous
                section.contentInsets = NSDirectionalEdgeInsets(top: 0,
                                                                leading: 16,
                                                                bottom: 16,
                                                                trailing: 0)
                
                let headerSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0),
                                                        heightDimension: .absolute(44))
                let header = NSCollectionLayoutBoundarySupplementaryItem(
                    layoutSize: headerSize,
                    elementKind: UICollectionView.elementKindSectionHeader,
                    alignment: .top
                )
                
                section.boundarySupplementaryItems = [header]
                return section
                
            } else {
                
                let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0),
                                                      heightDimension: .fractionalHeight(1.0))
                let item = NSCollectionLayoutItem(layoutSize: itemSize)
                
                
                let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalHeight(0.2),
                                                       heightDimension: .fractionalHeight(0.2))
                let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize,
                                                               subitems: [item])
                
                let section = NSCollectionLayoutSection(group: group)
                section.interGroupSpacing = 16
                section.contentInsets = NSDirectionalEdgeInsets(top: 0,
                                                                leading: 16,
                                                                bottom: 16,
                                                                trailing: 16)
                section.orthogonalScrollingBehavior = .continuous
                
                let headerSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0),
                                                        heightDimension: .absolute(44))
                let header = NSCollectionLayoutBoundarySupplementaryItem(
                    layoutSize: headerSize,
                    elementKind: UICollectionView.elementKindSectionHeader,
                    alignment: .top
                )
                
                section.boundarySupplementaryItems = [header]
                
                return section
                
            }
            
        }
    
    }
    
}
