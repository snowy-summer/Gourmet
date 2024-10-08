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
import Toast
import iamport_ios

final class PostDetailViewController: UIViewController {
    
    private lazy var collectionView = UICollectionView(frame: .zero,
                                                       collectionViewLayout: createLayout())
    private let buyButton = UIButton()
    private var dataSource: UICollectionViewDiffableDataSource<PostDetailSection, PostDetailViewModel.Item>!
    private let viewModel: PostDetailViewModel
    private let disposeBag = DisposeBag()
    
    init(recipe: PostDTO) {
        self.viewModel = PostDetailViewModel(recipe: recipe,
                                             networkManger: NetworkManager.shared)
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
                    
                case .deleteSuccess:
                    owner.view.makeToast("삭제 성공") { _ in
                        owner.navigationController?.popViewController(animated: true)
                    }
                    
                case .deleteFail(let error):
                    owner.view.makeToast(error.description)
                    
                case .needReLogin:
                    owner.resetViewController(vc: OnboardingViewController())
                    
                case .buySuccess:
                    owner.view.makeToast("결제 성공")
                }
                
            }.disposed(by: disposeBag)
        
    }
    
}

extension PostDetailViewController: PostDetailTitleCellDelegate {
    
    func resetViewController() {
        resetViewController(vc: OnboardingViewController())
    }
}

//MARK: - CollectionView
extension PostDetailViewController {
    
    typealias imageTitleRegisteration = UICollectionView.CellRegistration<PostDetailTitleCell, PostDTO>
    typealias ingredientRegisteration = UICollectionView.CellRegistration<PostDetailIngredientCell, RecipeIngredient>
    typealias recipeRegisteration = UICollectionView.CellRegistration<PostDetailRecipeStepCell, RecipeContent>
    
    
    //MARK: - CollectoinView Configuraion
    private func registImageTitleCell() -> imageTitleRegisteration {
        
        let cellRegistration = imageTitleRegisteration { cell, indexPath, itemIdentifier in
            cell.delegate = self
        }
        
        return cellRegistration
    }
    
    private func registIngredientCell() -> ingredientRegisteration {
        
        let cellRegistration = ingredientRegisteration { cell, indexPath, itemIdentifier in
            
        }
        
        return cellRegistration
    }
    
    private func registRecipeCell() -> recipeRegisteration {
        
        let cellRegistration = recipeRegisteration { cell, indexPath, itemIdentifier in
            
            cell.layer.cornerRadius = 8
            cell.clipsToBounds = true
        }
        
        return cellRegistration
    }
    
    private func configureDataSource() {
        
        let imageTitleRegistraion = registImageTitleCell()
        let ingredientRegistraion = registIngredientCell()
        let recipeRegistraion = registRecipeCell()
        
        dataSource = UICollectionViewDiffableDataSource(collectionView: collectionView,
                                                        cellProvider: { collectionView, indexPath, itemIdentifier in
            
            switch itemIdentifier {
            case .imageTitle(let recipe):
                let cell = collectionView.dequeueConfiguredReusableCell(using: imageTitleRegistraion,
                                                                        for: indexPath,
                                                                        item: recipe)
                cell.updateContent(item: recipe)
                return cell
                
            case .ingredient(let recipe):
                let cell = collectionView.dequeueConfiguredReusableCell(using: ingredientRegistraion,
                                                                        for: indexPath,
                                                                        item: recipe)
                cell.updateContent(item: recipe)
                return cell
                
            case .recipeContent(let recipe):
                let cell = collectionView.dequeueConfiguredReusableCell(using: recipeRegistraion,
                                                                        for: indexPath,
                                                                        item: recipe)
                cell.updateContent(item: recipe)
                return cell
            }
            
            
        })
        
        
    }
    
    private func updateSnapshot(recipe: PostDTO) {
        
        var recipeSnapshot = NSDiffableDataSourceSnapshot<PostDetailSection,PostDetailViewModel.Item>()
        recipeSnapshot.appendSections(PostDetailSection.allCases)
        recipeSnapshot.appendItems([.imageTitle(recipe)],
                                   toSection: .imageTitle)
        recipeSnapshot.appendItems(viewModel.ingredients,
                                   toSection: .ingredient)
        recipeSnapshot.appendItems(viewModel.recipeStep,
                                   toSection: .recipeStap)
        
        dataSource.apply(recipeSnapshot)
    }
    
    private func createLayout() -> UICollectionViewLayout {
        
        return UICollectionViewCompositionalLayout { sectionIndex, layoutEnvironment -> NSCollectionLayoutSection? in
            
            let section = PostDetailSection(rawValue: sectionIndex)
            return section?.layout
        }
    }
    
}

// MARK: - Configuration
extension PostDetailViewController: BaseViewProtocol {
    
    func configureNavigationBar() {
        
        let menuButton = UIBarButtonItem(image: UIImage(systemName: "ellipsis"),
                                         style: .plain,
                                         target: self,
                                         action: nil)
        
        menuButton.menu = UIMenu(children: configureMenu())
        
        navigationItem.rightBarButtonItem = menuButton
    }
    
    private func configureMenu() -> [UIAction] {
        
        let edit = UIAction(title: "수정",
                            image: UIImage(systemName: "pencil")) { [weak self] _ in
            guard let self = self else { return }
            
        }
        
        let delete = UIAction(title: "삭제",
                              image: UIImage(systemName: "trash")) { [weak self] _ in
            guard let self = self else { return }
            
            viewModel.apply(.deletePost)
        }
        
        let items = [
            edit,
            delete
        ]
        
        return items
    }
    
    func configureHierarchy() {
        
        view.addSubview(collectionView)
        view.addSubview(buyButton)
    }
    
    func configureUI() {
        
        view.backgroundColor = .systemBackground
        collectionView.register(PostDetailTitleCell.self,
                                forCellWithReuseIdentifier: PostDetailTitleCell.identifier)
        
        buyButton.setTitle("구매하기", for: .normal)
        buyButton.backgroundColor = .main
        buyButton.layer.cornerRadius = 16
    }
    
    func configureLayout() {
        
        
        collectionView.snp.makeConstraints { make in
            make.directionalHorizontalEdges.equalTo(view.safeAreaLayoutGuide)
            make.top.equalTo(view.safeAreaLayoutGuide)
            make.bottom.equalTo(buyButton.snp.top).offset(-16)
        }
        
        buyButton.snp.makeConstraints { make in
            make.directionalHorizontalEdges.equalTo(view.safeAreaLayoutGuide).inset(16)
            make.bottom.equalTo(view.safeAreaLayoutGuide).offset(-16)
            make.height.equalTo(44)
        }
    }
    
    func configureGestureAndButtonActions() {
        
        let payment = IamportPayment(
            pg: PG.html5_inicis.makePgRawName(pgId: "INIpayTest"),
            merchant_uid: "ios_\(Header.sesacKey.value)_\(Int(Date().timeIntervalSince1970))",
            amount: "100").then {
                $0.pay_method = PayMethod.card.rawValue
                $0.name = self.viewModel.recipe.title
                $0.buyer_name = "최승범"
                $0.app_scheme = "sesac"
            }
        
        buyButton.rx.tap
            .bind(with: self) { owner , _ in
                
                Iamport.shared.payment(navController: owner.navigationController!,
                                       userCode: "imp57573124",
                                       payment: payment)
                { [weak self] iamportResponse in
                    
                    self?.viewModel.apply(.checkPayment(iamportResponse?.imp_uid))
                }
            }
            .disposed(by: disposeBag)
        
        
        
        
    }
    
}

private enum PostDetailSection: Int, CaseIterable {
    case imageTitle
    case ingredient
    case recipeStap
    
    var layout: NSCollectionLayoutSection {
        switch self {
        case .imageTitle:
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
            return section
            
        case .ingredient:
            let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0),
                                                  heightDimension: .fractionalHeight(1.0))
            let item = NSCollectionLayoutItem(layoutSize: itemSize)
            
            
            let groupSize = NSCollectionLayoutSize(widthDimension: .absolute(80),
                                                   heightDimension: .absolute(120))
            let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize,
                                                           subitems: [item])
            
            let section = NSCollectionLayoutSection(group: group)
            section.interGroupSpacing = 16
            section.orthogonalScrollingBehavior = .continuous
            section.contentInsets = NSDirectionalEdgeInsets(top: 16,
                                                            leading: 16,
                                                            bottom: 16,
                                                            trailing: 16)
            return section
            
        case .recipeStap:
            let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0),
                                                  heightDimension: .fractionalHeight(1.0))
            let item = NSCollectionLayoutItem(layoutSize: itemSize)
            
            
            let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(0.9),
                                                   heightDimension: .estimated(300))
            let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize,
                                                           subitems: [item])
            
            
            let section = NSCollectionLayoutSection(group: group)
            section.interGroupSpacing = 16
            section.contentInsets = NSDirectionalEdgeInsets(top: 0,
                                                            leading: 16,
                                                            bottom: 0,
                                                            trailing: 16)
            section.orthogonalScrollingBehavior = .paging
            return section
        }
    }
}
