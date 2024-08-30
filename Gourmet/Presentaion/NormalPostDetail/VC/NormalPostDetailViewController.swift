//
//  NormalPostDetailViewController.swift
//  Gourmet
//
//  Created by 최승범 on 8/30/24.
//

import UIKit
import SnapKit
import RxSwift
import RxCocoa

final class NormalPostDetailViewController: UIViewController {
    
    private let tableView = UITableView()
    private var dataSource: UITableViewDiffableDataSource<NormalPostDetailSection,NormalPostDetailViewModel.Item>!
    private let commentEditView = CommentEditView()
    
    private let viewModel = NormalPostDetailViewModel(networkManager: NetworkManager.shared)
    private let disposeBag = DisposeBag()
    
    init(postId: String) {
        super.init(nibName: nil, bundle: nil)
        
        viewModel.getPostId(postId)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureView()
        configureDataSource()
        bindingOutPut()
        viewModel.apply(.reloadView)
    }
}

extension NormalPostDetailViewController {
    
    private func bindingOutPut() {
        
        viewModel.output.bind(with: self) { owner, output in
            
            switch output {
            case .noValue:
                return
                
            case .reloadView(let post):
                owner.updateSnapshot(item: post)
                
            case .needReLogin:
                owner.resetViewController(vc: OnboardingViewController())
            }
        }
        .disposed(by: disposeBag)
    }
}

//MARK: - TableView
extension NormalPostDetailViewController {
    
    private func configureDataSource() {
        
        dataSource = UITableViewDiffableDataSource(tableView: tableView) { tableView, indexPath, itemIdentifier in
            switch itemIdentifier {
            case .main(let post):
                guard let cell = tableView.dequeueReusableCell(withIdentifier: NormalPostDetailCell.identifier,
                                                               for: indexPath) as? NormalPostDetailCell else {
                    return NormalPostDetailCell()
                }
                
                cell.updateContent(item: post)
                return cell
                
            case .comment(let comment):
                guard let cell = tableView.dequeueReusableCell(withIdentifier: CommentTableViewCell.identifier,
                                                               for: indexPath) as? CommentTableViewCell else {
                    return CommentTableViewCell()
                }
                
                cell.updateContent(item: comment)
                return cell
            }
            
        }
    }
    
    private func updateSnapshot(item: PostDTO) {
        
        var snapshot = NSDiffableDataSourceSnapshot<NormalPostDetailSection,NormalPostDetailViewModel.Item>()
        snapshot.appendSections(NormalPostDetailSection.allCases)
        snapshot.appendItems([.main(item)],
                             toSection: .main)
        snapshot.appendItems(item.comments.map { NormalPostDetailViewModel.Item.comment($0) },
                             toSection: .comments)
        
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
extension NormalPostDetailViewController: BaseViewProtocol {
    
    func configureHierarchy() {
        
        view.addSubview(tableView)
        view.addSubview(commentEditView)
    }
    
    func configureUI() {
        
        view.backgroundColor = .systemBackground
        tableView.register(NormalPostDetailCell.self,
                           forCellReuseIdentifier: NormalPostDetailCell.identifier)
        tableView.register(CommentTableViewCell.self,
                           forCellReuseIdentifier: CommentTableViewCell.identifier)
        
        commentEditView.backgroundColor = .lightGray.withAlphaComponent(0.3)
        commentEditView.layer.cornerRadius = 8
        
        configureRefreshControl()
    }
    
    func configureLayout() {
        
        tableView.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide)
            make.directionalHorizontalEdges.equalTo(view.safeAreaLayoutGuide)
            make.bottom.equalTo(commentEditView.snp.top)
        }
        
        commentEditView.snp.makeConstraints { make in
            make.directionalHorizontalEdges.equalTo(view.safeAreaLayoutGuide)
            make.bottom.equalTo(view.safeAreaLayoutGuide)
            make.height.equalTo(44)
        }
        
    }
    
    private func configureRefreshControl () {
        
        let refreshControl = UIRefreshControl()
        tableView.refreshControl = refreshControl
        refreshControl.rx.controlEvent(.valueChanged)
            .subscribe(with: self) { owner, _ in
                owner.viewModel.apply(.reloadView)
                refreshControl.endRefreshing()
            }
            .disposed(by: disposeBag)
    }
    
}

private enum NormalPostDetailSection: Int, CaseIterable {
    case main
    case comments
}
