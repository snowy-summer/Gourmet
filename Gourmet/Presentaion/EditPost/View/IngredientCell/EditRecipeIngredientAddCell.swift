//
//  EditRecipeIngredientAddCell.swift
//  Gourmet
//
//  Created by 최승범 on 8/22/24.
//

import UIKit
import SnapKit
import RxSwift
import RxCocoa

protocol EditRecipeIngredientAddCellDelegate: AnyObject {
    func addIngredient(_ value: IngredientContent)
}

final class EditRecipeIngredientAddCell: UICollectionViewCell {
    
    private lazy var ingredientImageCollectionView = UICollectionView(frame: .zero,
                                                                      collectionViewLayout: createLayout())
    private var dataSource: UICollectionViewDiffableDataSource<IngredientImageSection, IngredientType>!
    
    private let headerView = HeaderView()
    private let containerView = UIView()
    private let nameLabel = UILabel()
    private let nameTextField = UITextField()
    private let valueLabel = UILabel()
    private let valueTextField = UITextField()
    private let addButton = UIButton()
    
    private let viewModel = IngredientViewModel()
    weak var delegate: EditRecipeIngredientAddCellDelegate?
    private let disposeBag = DisposeBag()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        configureView()
        configureDataSource()
        updateSnapshot()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

extension EditRecipeIngredientAddCell: UICollectionViewDelegate {
    
    typealias registerationImageCell = UICollectionView.CellRegistration<IngredientImageCell, IngredientType>
    
    //MARK: - Delegate Method
    func collectionView(_ collectionView: UICollectionView,
                        didSelectItemAt indexPath: IndexPath) {
        viewModel.apply(.selectIngredientType(indexPath.item))
    }
    
    //MARK: - CollectoinView Configuraion
    private func registImageCell() -> registerationImageCell {
        
        let cellRegistration = registerationImageCell { cell, indexPath, itemIdentifier in
            
        }
        
        return cellRegistration
    }
    
    private func configureDataSource() {
        
        let imageRegistration = registImageCell()
        
        dataSource = UICollectionViewDiffableDataSource(collectionView: ingredientImageCollectionView,
                                                        cellProvider: { collectionView, indexPath, itemIdentifier in
            
            
            let cell = collectionView.dequeueConfiguredReusableCell(using: imageRegistration,
                                                                    for: indexPath,
                                                                    item: itemIdentifier)
            cell.updateContent(item: itemIdentifier)
            return cell
            
        })
        
    }
    
    private func updateSnapshot() {
        
        var snapshot = NSDiffableDataSourceSnapshot<IngredientImageSection, IngredientType>()
        snapshot.appendSections(IngredientImageSection.allCases)
        snapshot.appendItems(IngredientType.allCases,
                             toSection: .image)
        
        dataSource.apply(snapshot)
    }
    
    
    private func createLayout() -> UICollectionViewLayout {
        
        let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0),
                                              heightDimension: .fractionalHeight(1.0))
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        
        
        let groupSize = NSCollectionLayoutSize(widthDimension: .absolute(60),
                                               heightDimension: .absolute(60))
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize,
                                                       subitems: [item])
        
        let section = NSCollectionLayoutSection(group: group)
        section.interGroupSpacing = 8
        section.orthogonalScrollingBehavior = .continuous
        section.contentInsets = NSDirectionalEdgeInsets(top: 16,
                                                        leading: 16,
                                                        bottom: 16,
                                                        trailing: 16)
        
        let layout = UICollectionViewCompositionalLayout(section: section)
        
        return layout
    }
}

//MARK: - Configuraion
extension EditRecipeIngredientAddCell: BaseViewProtocol {
    
    func configureHierarchy() {
        
        contentView.addSubview(headerView)
        contentView.addSubview(ingredientImageCollectionView)
        contentView.addSubview(containerView)
        
        containerView.addSubview(nameLabel)
        containerView.addSubview(nameTextField)
        containerView.addSubview(valueLabel)
        containerView.addSubview(valueTextField)
        contentView.addSubview(addButton)
    }
    
    func configureUI() {
        
        headerView.configureContent(type: .ingredientAdd)
        
        ingredientImageCollectionView.backgroundColor = .lightGray.withAlphaComponent(0.3)
        ingredientImageCollectionView.layer.cornerRadius = 8
        
        containerView.backgroundColor = .lightGray.withAlphaComponent(0.3)
        containerView.layer.cornerRadius = 8
        
        nameLabel.text = "이름:"
        valueLabel.text = "용량:"
        
        nameTextField.setUnderLine(color: .black)
        valueTextField.setUnderLine(color: .black)
        
        addButton.backgroundColor = .main
        addButton.setTitle("추가", for: .normal)
        addButton.layer.cornerRadius = 8
        addButton.layer.cornerCurve = .continuous
    }
    
    func configureLayout() {
        
        headerView.snp.makeConstraints { make in
            make.top.equalTo(contentView.snp.top).offset(4)
            make.directionalHorizontalEdges.equalTo(contentView.snp.directionalHorizontalEdges).inset(8)
            make.height.equalTo(44)
        }
        
        ingredientImageCollectionView.snp.makeConstraints { make in
            make.top.equalTo(headerView.snp.bottom).offset(8)
            make.directionalHorizontalEdges.equalTo(contentView.snp.directionalHorizontalEdges).inset(16)
        }
        
        containerView.snp.makeConstraints { make in
            make.top.equalTo(ingredientImageCollectionView.snp.bottom).offset(16)
            make.height.equalTo(44)
            make.leading.equalTo(contentView.snp.leading).offset(16)
            make.bottom.equalTo(contentView.snp.bottom).inset(16)
        }
        
        nameLabel.snp.makeConstraints { make in
            make.directionalVerticalEdges.equalToSuperview().inset(4)
            make.leading.equalToSuperview().offset(8)
        }
        
        nameTextField.snp.makeConstraints { make in
            make.directionalVerticalEdges.equalToSuperview().inset(4)
            make.leading.equalTo(nameLabel.snp.trailing).offset(8)
            make.width.equalTo(containerView.snp.width).multipliedBy(0.3)
        }
        
        valueLabel.snp.makeConstraints { make in
            make.directionalVerticalEdges.equalToSuperview().inset(4)
            make.leading.equalTo(nameTextField.snp.trailing).offset(16)
        }
        
        valueTextField.snp.makeConstraints { make in
            make.directionalVerticalEdges.equalToSuperview().inset(4)
            make.leading.equalTo(valueLabel.snp.trailing).offset(8)
            make.width.equalTo(containerView.snp.width).multipliedBy(0.2)
        }
        
        addButton.snp.makeConstraints { make in
            make.top.equalTo(ingredientImageCollectionView.snp.bottom).offset(16)
            make.leading.equalTo(containerView.snp.trailing).offset(8)
            make.trailing.equalTo(contentView.snp.trailing).inset(16)
            make.bottom.equalTo(contentView.snp.bottom).inset(16)
            make.height.equalTo(44)
            make.width.equalTo(60)
        }
    }
    
    func configureGestureAndButtonActions() {
        
        addButton.rx.tap
            .withLatestFrom(Observable.combineLatest(nameTextField.rx.text.orEmpty,
                                                     valueTextField.rx.text.orEmpty))
            .bind(with: self) { owner, value in
                owner.delegate?.addIngredient(IngredientContent(type: owner.viewModel.selectIngredientType,
                                                                name: value.0,
                                                                value: value.1))
            }
            .disposed(by: disposeBag)
    }
}

private enum IngredientImageSection: CaseIterable {
    case image
}
