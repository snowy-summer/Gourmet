//
//  EditRecipeCategoryCell.swift
//  Gourmet
//
//  Created by 최승범 on 8/29/24.
//

import UIKit
import SnapKit
import RxSwift
import RxCocoa

protocol EditRecipeCategoryCellDelegate: AnyObject {
    func selectFoodCategory(item: Int)
}

final class EditRecipeCategoryCell: UICollectionViewCell {
    
    private lazy var collectionView = UICollectionView(frame: .zero,
                                                                      collectionViewLayout: createLayout())
    private var dataSource: UICollectionViewDiffableDataSource<CategorySection, EditRecipeFoodCategory>!
    
    private let headerView = HeaderView()
    
    private let viewModel = EditCategoryViewModel()
    weak var delegate: EditRecipeCategoryCellDelegate?
    private let disposeBag = DisposeBag()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        configureView()
        configureDataSource()
        bindingOutput()
        updateSnapshot()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

extension EditRecipeCategoryCell {
    
    private func bindingOutput() {
        
        viewModel.output.bind(with: self) { owner, output in
            
            switch output {
            case .noValue:
                return
                
            case .updateSnapshot:
                owner.updateSnapshot()
            }
        }
        .disposed(by: disposeBag)
    }
}

//MARK: - CollectionView configure, Delegate
extension EditRecipeCategoryCell: UICollectionViewDelegate {
    
    typealias registerationImageCell = UICollectionView.CellRegistration<CategorycomponentCell, EditRecipeFoodCategory>
    
    //MARK: - Delegate Method
    func collectionView(_ collectionView: UICollectionView,
                        didSelectItemAt indexPath: IndexPath) {
        viewModel.apply(.selectedCategory(indexPath.item))
        delegate?.selectFoodCategory(item: indexPath.item)
    }
    
    //MARK: - CollectoinView Configuraion
    private func registImageCell() -> registerationImageCell {
        
        let cellRegistration = registerationImageCell { cell, indexPath, itemIdentifier in
            
        }
        
        return cellRegistration
    }
    
    private func configureDataSource() {
        
        let imageRegistration = registImageCell()
        
        dataSource = UICollectionViewDiffableDataSource(collectionView: collectionView,
                                                        cellProvider: { collectionView, indexPath, itemIdentifier in
            
            
            let cell = collectionView.dequeueConfiguredReusableCell(using: imageRegistration,
                                                                    for: indexPath,
                                                                    item: itemIdentifier)
            cell.updateContent(item: itemIdentifier)
            return cell
            
        })
        
    }
    
    private func updateSnapshot() {
        
        var snapshot = NSDiffableDataSourceSnapshot<CategorySection, EditRecipeFoodCategory>()
        snapshot.appendSections(CategorySection.allCases)
        snapshot.appendItems(viewModel.category,
                             toSection: .image)
        
        dataSource.apply(snapshot)
    }
    
    private func createLayout() -> UICollectionViewLayout {
        
        let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0),
                                              heightDimension: .fractionalHeight(1.0))
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        
        
        let groupSize = NSCollectionLayoutSize(widthDimension: .absolute(80),
                                               heightDimension: .estimated(100))
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize,
                                                       subitems: [item])
        let section = NSCollectionLayoutSection(group: group)
        section.orthogonalScrollingBehavior = .continuous
        section.interGroupSpacing = 8
        
        section.contentInsets = NSDirectionalEdgeInsets(top: 8,
                                                        leading: 20,
                                                        bottom: 8,
                                                        trailing: 20)
        
        let layout = UICollectionViewCompositionalLayout(section: section)
        
        return layout
    }
}

//MARK: - Configuraion
extension EditRecipeCategoryCell: BaseViewProtocol {
    
    func configureHierarchy() {
        
        contentView.addSubview(headerView)
        contentView.addSubview(collectionView)
    }
    
    func configureUI() {
        
        headerView.configureContent(type: .category)
        
        collectionView.backgroundColor = .lightGray.withAlphaComponent(0.3)
        collectionView.layer.cornerRadius = 8
        collectionView.delegate = self
    }
    
    func configureLayout() {
        
        headerView.snp.makeConstraints { make in
            make.top.equalTo(contentView.snp.top).offset(4)
            make.directionalHorizontalEdges.equalTo(contentView.snp.directionalHorizontalEdges).inset(8)
            make.height.equalTo(44)
        }
        
        collectionView.snp.makeConstraints { make in
            make.top.equalTo(headerView.snp.bottom).offset(8)
            make.directionalHorizontalEdges.equalTo(contentView.snp.directionalHorizontalEdges).inset(16)
            make.bottom.equalTo(contentView.snp.bottom).inset(16)
        }
      
    }
}

private enum CategorySection: CaseIterable {
    case image
}
