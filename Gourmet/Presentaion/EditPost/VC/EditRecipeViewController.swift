//
//  EditRecipeViewController.swift
//  Gourmet
//
//  Created by 최승범 on 8/22/24.
//

import UIKit
import SnapKit
import RxSwift
import RxCocoa

final class EditRecipeViewController: UIViewController {
    
    enum Item: Hashable {
        case title(String?)
        case ingredient(RecipeIngredient)
        case content(RecipeContent)
        case neededTime(String)
        case price(Int)
    }
    
    private let viewModel = EditPostViewModel(networkManager: NetworkManager.shared)
    private let disposeBag = DisposeBag()
    
    private var dataSource: UICollectionViewDiffableDataSource<EditRecipeSection, Item>!
    private lazy var collectionView = UICollectionView(frame: .zero,
                                                       collectionViewLayout: createLayout())
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureView()
        configureDataSource()
        updateSnapshot()
        bindingOutput()
    }
}

extension EditRecipeViewController {
    
    private func bindingOutput() {
        
    }
    
}

//MARK: - CollectionView
extension EditRecipeViewController {
    
    typealias registerationTitle = UICollectionView.CellRegistration<EditRecipeTitleCell, String?>
    typealias registerationIngredient = UICollectionView.CellRegistration<EditRecipeIngredientCell, RecipeIngredient>
    typealias registerationContent = UICollectionView.CellRegistration<EditRecipeContentCell, RecipeContent>
    typealias registerationTime = UICollectionView.CellRegistration<EditRecipeTimeCell, String>
    typealias header = UICollectionView.SupplementaryRegistration<TitleHeaderView>
    
    private func registTitleCell() -> registerationTitle {
        
        let cellRegistration = registerationTitle { cell, indexPath, itemIdentifier in
            
        }
        
        return cellRegistration
    }
    
    private func registIngredientCell() -> registerationIngredient {
        
        let cellRegistration = registerationIngredient { cell, indexPath, itemIdentifier in
            
        }
        
        return cellRegistration
    }
    
    private func registContentCell() -> registerationContent {
        
        let cellRegistration = registerationContent { cell, indexPath, itemIdentifier in
            
        }
        
        return cellRegistration
    }
    
    private func registTimeCell() -> registerationTime {
        
        let cellRegistration = registerationTime { cell, indexPath, itemIdentifier in
            
        }
        
        return cellRegistration
    }
    
    private func registHeader() -> header {
        
        let headerRegistration = header(elementKind: UICollectionView.elementKindSectionHeader) { view, elementKind, indexPath in
            
            view.updateText(title: EditRecipeSection.allCases[indexPath.section].headerTitle)
        }
        
        return headerRegistration
    }
    
    private func configureDataSource() {
        
        let headerRegistration = registHeader()
        let titleRegistration = registTitleCell()
        let ingredientRegistration = registIngredientCell()
        let contentRegistration = registContentCell()
        let timeRegistration = registTimeCell()
        
        dataSource = UICollectionViewDiffableDataSource(collectionView: collectionView,
                                                        cellProvider: { collectionView, indexPath, itemIdentifier in
            
            switch itemIdentifier {
            case .title(let title):
                let cell = collectionView.dequeueConfiguredReusableCell(using: titleRegistration,
                                                                        for: indexPath,
                                                                        item: title)
                cell.updateContent(item: title)
                return cell
                
            case .ingredient(let ingredient):
                let cell = collectionView.dequeueConfiguredReusableCell(using: ingredientRegistration,
                                                                        for: indexPath,
                                                                        item: ingredient)
                cell.updateContent(item: ingredient)
                return cell
                
            case .content(let content):
                let cell = collectionView.dequeueConfiguredReusableCell(using: contentRegistration,
                                                                        for: indexPath,
                                                                        item: content)
                cell.updateContent(item: content)
                return cell
                
            case .neededTime(let time):
                let cell = collectionView.dequeueConfiguredReusableCell(using: timeRegistration,
                                                                        for: indexPath,
                                                                        item: time)
                cell.updateContent(item: time)
                return cell
                
            case .price(let price):
                let cell = collectionView.dequeueConfiguredReusableCell(using: contentRegistration,
                                                                        for: indexPath,
                                                                        item: RecipeContent(thumbnailImage: nil,
                                                                                            contet: ""))
                return cell
            }
            
        })
        
        dataSource.supplementaryViewProvider = { collectionView, kind, indexPath in
            
            return collectionView.dequeueConfiguredReusableSupplementary(using: headerRegistration,
                                                                         for: indexPath)
        }
    }
    
    private func updateSnapshot() {
        
        var snapshot = NSDiffableDataSourceSnapshot<EditRecipeSection,Item>()
        snapshot.appendSections(EditRecipeSection.allCases)
        snapshot.appendItems([.title("")],
                             toSection: .title)
        snapshot.appendItems([
            .ingredient(RecipeIngredient(name: "양갈비", value: "250g")),
            .ingredient(RecipeIngredient(name: "버섯", value: "50g")),
        ],
                             toSection: .ingredient)
        snapshot.appendItems([
            .content(RecipeContent(thumbnailImage: UIImage(systemName: "star"), contet: "아주 잘 굽는다")),
            .content(RecipeContent(thumbnailImage: nil, contet: "", isAddCell: true)),
        ],
                             toSection: .content)
        snapshot.appendItems([.neededTime("30 min")],
                             toSection: .time)
        snapshot.appendItems([],
                             toSection: .price)
        dataSource.apply(snapshot)
    }
    
    private func createLayout() -> UICollectionViewLayout {
        
        return UICollectionViewCompositionalLayout { sectionIndex, layoutEnvironment -> NSCollectionLayoutSection? in
            
            let section = EditRecipeSection(rawValue: sectionIndex)
            return section?.layoutSection(with: layoutEnvironment)
        }
    }
    
}
//MARK: - Configuration
extension EditRecipeViewController: BaseViewProtocol {
    
    func configureHierarchy() {
        view.addSubview(collectionView)
    }
    
    func configureUI() {
        
        view.backgroundColor = .main
        collectionView.backgroundColor = .main
    }
    
    func configureLayout() {
        collectionView.snp.makeConstraints { make in
            make.directionalEdges.equalTo(view.safeAreaLayoutGuide)
        }
    }
    
}

fileprivate enum EditRecipeSection: Int, CaseIterable {
    case title
    case ingredient
    case content
    case time
    case price
    
    var headerTitle: String {
        switch self {
        case .title:
            return "제목"
            
        case .ingredient:
            return "재료"
            
        case .content:
            return "내용"
            
        case .time:
            return "시간"
            
        case .price:
            return "가격"
        }
    }
    
    func layoutSection(with layoutEnvironment: NSCollectionLayoutEnvironment) -> NSCollectionLayoutSection {
        
        switch self {
        case .title:
            let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0),
                                                  heightDimension: .fractionalHeight(1.0))
            let item = NSCollectionLayoutItem(layoutSize: itemSize)
            
            
            let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0),
                                                   heightDimension: .absolute(60))
            let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize,
                                                           subitems: [item])
            group.contentInsets = NSDirectionalEdgeInsets(top: 0,
                                                          leading: 0,
                                                          bottom: 8,
                                                          trailing: 0)
            
            let section = NSCollectionLayoutSection(group: group)
            
            section.contentInsets = NSDirectionalEdgeInsets(top: 0,
                                                            leading: 16,
                                                            bottom: 8,
                                                            trailing: 16)
            
            return section
            
        case .ingredient:
            var configuration = UICollectionLayoutListConfiguration(appearance: .insetGrouped)
            configuration.backgroundColor = .main
            
            let section = NSCollectionLayoutSection.list(using: configuration,
                                                         layoutEnvironment: layoutEnvironment)
            
            section.interGroupSpacing = 4
            section.contentInsets = NSDirectionalEdgeInsets(top: 0,
                                                            leading: 16,
                                                            bottom: 8,
                                                            trailing: 16)
            let headerSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0),
                                                    heightDimension: .absolute(44))
            let header = NSCollectionLayoutBoundarySupplementaryItem(
                layoutSize: headerSize,
                elementKind: UICollectionView.elementKindSectionHeader,
                alignment: .top
            )
            
            section.boundarySupplementaryItems = [header]
            
            return section
            
        case .time:
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
                                                            bottom: 8,
                                                            trailing: 16)
            
            let headerSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0),
                                                    heightDimension: .absolute(44))
            let header = NSCollectionLayoutBoundarySupplementaryItem(
                layoutSize: headerSize,
                elementKind: UICollectionView.elementKindSectionHeader,
                alignment: .top
            )
            
            section.boundarySupplementaryItems = [header]
            
            return section
            
        default:
            let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0),
                                                  heightDimension: .fractionalHeight(1.0))
            let item = NSCollectionLayoutItem(layoutSize: itemSize)
            
            
            let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0),
                                                   heightDimension: .fractionalHeight(0.2))
            let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize,
                                                           subitems: [item])
            group.contentInsets = NSDirectionalEdgeInsets(top: 0,
                                                          leading: 0,
                                                          bottom: 8,
                                                          trailing: 0)
            
            let section = NSCollectionLayoutSection(group: group)
            
            section.contentInsets = NSDirectionalEdgeInsets(top: 0,
                                                            leading: 16,
                                                            bottom: 8,
                                                            trailing: 16)
            
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
