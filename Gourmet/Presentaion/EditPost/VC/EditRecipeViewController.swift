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
        
        viewModel.output.bind(with: self) { owner, output in
            switch output {
            case .noValue:
                return
                
            case .applySnapShot:
                owner.updateSnapshot()
                
            case .needReLogin:
                owner.resetViewController(vc: LoginViewController())
                
            }
        }.disposed(by: disposeBag)
    }
    
}

//MARK: - Edit View Delegate
extension EditRecipeViewController: EditRecipeTitleCellDelegate,
                                    EditRecipeCategoryCellDelegate,
                                    EditRecipeIngredientAddCellDelegate,
                                    EditRecipeTimeDelegate,
                                    EditRecipeContentAddCellDelegate {
    
    // Category
    func selectFoodCategory(item: Int) {
        viewModel.apply(.selectCategory(item))
    }
    
    // EditRecipeContentAddCellDelegate
    func presentPhotoPicker(picker: UIViewController) {
        present(picker, animated: true)
    }
    
    func addContent(_ value: RecipeContent) {
        viewModel.apply(.addContent(value))
    }
    
    //EditRecipeIngredientAddCellDelegate
    func addIngredient(_ value: IngredientContent) {
        viewModel.apply(.addIngredient(value))
    }
    
    //EditRecipeTitleCellDelegate
    func updateTitle(_ value: String) {
        viewModel.apply(.updateTitle(value))
    }
    
    //EditRecipeTimeDelegate
    func updateTime(_ value: String) {
        viewModel.apply(.updateTime(value))
    }
}

//MARK: - CollectionView
extension EditRecipeViewController {
    
    typealias registerationHeaderCell = UICollectionView.CellRegistration<EditRecipeHeaderCell, String?>
    typealias registerationTitle = UICollectionView.CellRegistration<EditRecipeTitleCell, String?>
    typealias registerationCategory = UICollectionView.CellRegistration<EditRecipeCategoryCell, String>
    
    typealias registerationIngredientAddCell = UICollectionView.CellRegistration<EditRecipeIngredientAddCell, String>
    typealias registerationIngredientContent = UICollectionView.CellRegistration<IngredientContentCell, IngredientContent>
    
    typealias registerationContentAddCell = UICollectionView.CellRegistration<RecipeContentAddCell, String>
    typealias registerationContent = UICollectionView.CellRegistration<EditRecipeContentCell, RecipeContent>
    
    typealias registerationTime = UICollectionView.CellRegistration<EditRecipeTimeCell, String>
    typealias registerationDifficultyLevel = UICollectionView.CellRegistration<EditRecipeDifficultyLevelCell, String>
    typealias header = UICollectionView.SupplementaryRegistration<TitleHeaderView>
    
    //MARK: - CollectoinView Configuraion
    private func registTitleCell() -> registerationTitle {
        
        let cellRegistration = registerationTitle { [weak self] cell, indexPath, itemIdentifier in
            
            guard let self = self else { return }
            cell.delegate = self
            cellBackgroundConfigure(cell: cell,
                                    color: .lightGray.withAlphaComponent(0.5))
        }
        
        return cellRegistration
    }
    
    private func registCategoryCell() -> registerationCategory {
        
        let cellRegistration = registerationCategory { [weak self] cell, indexPath, itemIdentifier in
            
            guard let self = self else { return }
            cell.delegate = self
            cellBackgroundConfigure(cell: cell,
                                    color: .lightGray.withAlphaComponent(0.5))
        }
        
        return cellRegistration
    }
    
    private func registIngredientAddCell() -> registerationIngredientAddCell {
        
        let cellRegistration = registerationIngredientAddCell { [weak self] cell, indexPath, itemIdentifier in
            
            guard let self = self else { return }
            cell.delegate = self
            cellBackgroundConfigure(cell: cell,
                                    color: .lightGray.withAlphaComponent(0.5))
        }
        
        return cellRegistration
    }
    
    private func registIngredientContentCell() -> registerationIngredientContent {
        
        let cellRegistration = registerationIngredientContent { [weak self] cell, indexPath, itemIdentifier in
            
            guard let self = self else { return }
            cellBackgroundConfigure(cell: cell,
                                    color: .lightGray.withAlphaComponent(0.5))
        }
        
        return cellRegistration
    }
    
    
    private func registContentAddCell() -> registerationContentAddCell {
        
        let cellRegistration = registerationContentAddCell { [weak self] cell, indexPath, itemIdentifier in
            
            guard let self = self else { return }
            cell.delegate = self
            cellBackgroundConfigure(cell: cell,
                                    color: .lightGray.withAlphaComponent(0.5))
        }
        
        return cellRegistration
    }
    
    private func registContentCell() -> registerationContent {
        
        let cellRegistration = registerationContent { [weak self] cell, indexPath, itemIdentifier in
            
            guard let self = self else { return }
            cellBackgroundConfigure(cell: cell,
                                    color: .lightGray.withAlphaComponent(0.5))
        }
        
        return cellRegistration
    }
    
    private func registTimeCell() -> registerationTime {
        
        let cellRegistration = registerationTime { [weak self] cell, indexPath, itemIdentifier in
            
            guard let self = self else { return }
            cell.delegate = self
            cellBackgroundConfigure(cell: cell,
                                    color: .lightGray.withAlphaComponent(0.5))
        }
        
        return cellRegistration
    }
    
    private func registDifficultyLevelCell() -> registerationDifficultyLevel {
        
        let cellRegistration = registerationDifficultyLevel { [weak self] cell, indexPath, itemIdentifier in
            
            guard let self = self else { return }
            cellBackgroundConfigure(cell: cell,
                                    color: .lightGray.withAlphaComponent(0.5))       
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
        let categoryRegistration = registCategoryCell()
        
        let ingredientRegistration = registIngredientAddCell()
        let ingredientContentRegistration = registIngredientContentCell()
        
        let contentAddCellRegistration = registContentAddCell()
        let contentRegistration = registContentCell()
        
        let timeRegistration = registTimeCell()
        let levelRegistration = registDifficultyLevelCell()
        
        dataSource = UICollectionViewDiffableDataSource(collectionView: collectionView,
                                                        cellProvider: { collectionView, indexPath, itemIdentifier in
            
            switch itemIdentifier {
            case .title(let title):
                let cell = collectionView.dequeueConfiguredReusableCell(using: titleRegistration,
                                                                        for: indexPath,
                                                                        item: title)
                cell.updateContent(item: title)
                return cell
                
            case .category(let category):
                let cell = collectionView.dequeueConfiguredReusableCell(using: categoryRegistration,
                                                                        for: indexPath,
                                                                        item: category)

                return cell
                
            case .ingredient(let ingredient):
                let cell = collectionView.dequeueConfiguredReusableCell(using: ingredientRegistration,
                                                                        for: indexPath,
                                                                        item: ingredient)
                
                return cell
                
            case .ingredientContent(let ingredientContent):
                let cell = collectionView.dequeueConfiguredReusableCell(using: ingredientContentRegistration,
                                                                        for: indexPath,
                                                                        item: ingredientContent)
                guard let ingredientContent = ingredientContent else { return cell }
                cell.updateContent(item: ingredientContent)
                return cell
                
            case .contentAdd(let content):
                let cell = collectionView.dequeueConfiguredReusableCell(using: contentAddCellRegistration,
                                                                        for: indexPath,
                                                                        item: content)
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
                
            case .difficulty(let level):
                
                let cell = collectionView.dequeueConfiguredReusableCell(using: levelRegistration,
                                                                        for: indexPath,
                                                                        item: level)
                cell.updateContent(item: level)
                return cell
                
            case .price(let price):
                let cell = collectionView.dequeueConfiguredReusableCell(using: contentRegistration,
                                                                        for: indexPath,
                                                                        item: RecipeContent(thumbnailImage: nil,
                                                                                            content: ""))
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
        snapshot.appendItems([.category("카테고리 선택 칸")],
                             toSection: .category)
        
        snapshot.appendItems([.ingredient("재료 추가 칸")],
                             toSection: .ingredientAdd)
        snapshot.appendItems(viewModel.generateItems(from: .ingredientContent(nil)),
                             toSection: .ingredientContent)
        
        snapshot.appendItems([.contentAdd("레시피 추가 칸")],
                             toSection: .contentAdd)
        snapshot.appendItems(viewModel.generateItems(from: .content(nil)),
                             toSection: .content)
        
        snapshot.appendItems(viewModel.generateItems(from: .neededTime("")),
                             toSection: .time)
        snapshot.appendItems(viewModel.generateItems(from: .difficulty("")),
                             toSection: .difficulty)
        
        dataSource.apply(snapshot)
    }
    
    private func createLayout() -> UICollectionViewLayout {
        
        return UICollectionViewCompositionalLayout { sectionIndex, layoutEnvironment -> NSCollectionLayoutSection? in
            
            let section = EditRecipeSection(rawValue: sectionIndex)
            return section?.layoutSection(with: layoutEnvironment)
        }
    }
    
    private func cellBackgroundConfigure(cell: UICollectionViewCell,
                                         color: UIColor) {
        
        var backgroundConfig = UIBackgroundConfiguration.listGroupedCell()
        backgroundConfig.backgroundColor = color
        backgroundConfig.cornerRadius = 8
        cell.backgroundConfiguration = backgroundConfig
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
        
        saveItem.rx.tap
            .bind(with: self) { owner, _ in
                owner.viewModel.apply(.saveContet)
                owner.navigationController?.popViewController(animated: true)
            }
            .disposed(by: disposeBag)
        
    }
    
    func configureHierarchy() {
        view.addSubview(collectionView)
    }
    
    func configureUI() {
        
        view.backgroundColor = .systemBackground
        collectionView.backgroundColor = .systemBackground
    }
    
    func configureLayout() {
        
        collectionView.snp.makeConstraints { make in
            make.directionalEdges.equalTo(view.safeAreaLayoutGuide)
        }
    }
    
}
