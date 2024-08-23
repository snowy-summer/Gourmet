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
    
    private let viewModel = EditPostViewModel(networkManager: NetworkManager.shared)
    private let disposeBag = DisposeBag()
    
    private var dataSource: UICollectionViewDiffableDataSource<EditRecipeSection, EditPostViewModel.Item>!
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
//        guard let saveButton = navigationItem.rightBarButtonItem else { return }
        
//        let input = EditPostViewModel.Input(saveButtonTap: saveButton.rx.tap)
        
//        let ouput = viewModel.transform(input)
        
        viewModel.output.bind(with: self) { owner, output in
            switch output {
            case .noValue:
                return
                
            case .applySnapShot:
                owner.updateSnapshot()

            }
        }.disposed(by: disposeBag)
    }
    
}

//MARK: - Edit View Delegate
extension EditRecipeViewController: EditIngredientViewDelegate {
    
    func dismissView(item: RecipeIngredient) {
//        viewModel.transform(.addIngredient(item))
        viewModel.apply(.addIngredient(item))
    }
}

//MARK: - CollectionView
extension EditRecipeViewController: UICollectionViewDelegate {
    
    typealias registerationTitle = UICollectionView.CellRegistration<EditRecipeTitleCell, String?>
    typealias registerationIngredient = UICollectionView.CellRegistration<EditRecipeIngredientCell, RecipeIngredient>
    typealias registerationContent = UICollectionView.CellRegistration<EditRecipeContentCell, RecipeContent>
    typealias registerationTime = UICollectionView.CellRegistration<EditRecipeTimeCell, String>
    typealias header = UICollectionView.SupplementaryRegistration<TitleHeaderView>
    
    
    //MARK: - Delegate Method
    func collectionView(_ collectionView: UICollectionView,
                        didSelectItemAt indexPath: IndexPath) {
        
        switch EditRecipeSection(rawValue: indexPath.section) {
        case .ingredient:
            let ingredient = viewModel.ingredients[indexPath.item]
            let vc = EditIngredientViewController(ingredient: ingredient)
            vc.delegate = self
            present(vc, animated: true)
            
            
        case .content:
            if viewModel.contents[indexPath.item].isAddCell {
//                present(EditIngredientViewController(), animated: true)
            }
            
        case .time:
            if viewModel.ingredients[indexPath.item].isAddCell {
//                present(EditIngredientViewController(), animated: true)
            }
            
        default:
            return
        }
        
    }
    
    //MARK: - CollectoinView Configuraion
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
                
                guard let ingredient = ingredient else { return cell }
                
                cell.updateContent(item: ingredient)
                return cell
                
            case .content(let content):
                let cell = collectionView.dequeueConfiguredReusableCell(using: contentRegistration,
                                                                        for: indexPath,
                                                                        item: content)
                guard let content = content else { return cell }
                
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
        
        var snapshot = NSDiffableDataSourceSnapshot<EditRecipeSection,EditPostViewModel.Item>()
        snapshot.appendSections(EditRecipeSection.allCases)
        snapshot.appendItems(viewModel.generateItems(from: .title(nil)),
                             toSection: .title)
        snapshot.appendItems(viewModel.generateItems(from: .ingredient(nil)),
                             toSection: .ingredient)
        snapshot.appendItems(viewModel.generateItems(from: .content(nil)),
                             toSection: .content)
        snapshot.appendItems(viewModel.generateItems(from: .neededTime("")),
                             toSection: .time)
        
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
    
    func configureNavigationBar() {
        
        let saveItem = UIBarButtonItem(title: "저장",
                                       style: .plain,
                                       target: self,
                                       action: nil)
        
        navigationItem.rightBarButtonItem = saveItem
        
    }
    
    func configureHierarchy() {
        view.addSubview(collectionView)
    }
    
    func configureUI() {
        
        view.backgroundColor = .main
        collectionView.backgroundColor = .main
        collectionView.delegate = self
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
            let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0),
                                                  heightDimension: .fractionalHeight(1.0))
            let item = NSCollectionLayoutItem(layoutSize: itemSize)
            
            
            let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0),
                                                   heightDimension: .absolute(44))
            let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize,
                                                           subitems: [item])
            group.contentInsets = NSDirectionalEdgeInsets(top: 0,
                                                          leading: 0,
                                                          bottom: 4,
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
            
        case .time:
            let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0),
                                                  heightDimension: .fractionalHeight(1.0))
            let item = NSCollectionLayoutItem(layoutSize: itemSize)
            
            
            let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0),
                                                   heightDimension: .absolute(44))
            let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize,
                                                           subitems: [item])
            
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
