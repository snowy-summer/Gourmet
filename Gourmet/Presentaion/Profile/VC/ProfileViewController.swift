//
//  ProfileViewController.swift
//  Gourmet
//
//  Created by 최승범 on 8/31/24.
//

import UIKit
import SnapKit
import RxSwift
import RxCocoa

final class ProfileViewController: UIViewController {
    
    private let tableView = UITableView()
    private var dataSource: UITableViewDiffableDataSource<ProfileSection,ProfileViewModel.Item>!
    
    private let viewModel = ProfileViewModel(networkManager: NetworkManager.shared)
    private let disposeBag = DisposeBag()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureView()
        configureDataSource()
        bindingOutPut()
        viewModel.apply(.viewDidLoad)
    }
}

extension ProfileViewController {
    
    private func bindingOutPut() {
        
        viewModel.output.bind(with: self) { owner, output in
            
            switch output {
            case .noValue:
                return
                
            case .viewDidLoad:
                owner.updateSnapshot()
                
            case .needReLogin:
                owner.resetViewController(vc: OnboardingViewController())
            }
        }
        .disposed(by: disposeBag)
    }
}

//MARK: - TableView
extension ProfileViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView,
                   didSelectRowAt indexPath: IndexPath) {
        
        switch ProfileSection(rawValue: indexPath.section) {
        case .normal:
            viewModel.apply(.selectMode(indexPath.item))
            
        default:
            return
        }
    }
    
    private func configureDataSource() {
        
        dataSource = UITableViewDiffableDataSource(tableView: tableView) { tableView, indexPath, itemIdentifier in
            switch itemIdentifier {
            case .profile(let user):
                guard let cell = tableView.dequeueReusableCell(withIdentifier: ProfileTableViewCell.identifier,
                                                               for: indexPath) as? ProfileTableViewCell else {
                    return ProfileTableViewCell()
                }
                
                cell.updateContent(item: user)
                return cell
                
            case .normal(let title):
                let cell = tableView.dequeueReusableCell(withIdentifier: UITableViewCell.identifier,
                                                               for: indexPath)
                
                cell.textLabel?.text = title
                return cell
            }
            
        }
    }
    
    private func updateSnapshot() {
        
        var snapshot = NSDiffableDataSourceSnapshot<ProfileSection,ProfileViewModel.Item>()
        snapshot.appendSections(ProfileSection.allCases)
        snapshot.appendItems(viewModel.profile,
                             toSection: .main)
        snapshot.appendItems(viewModel.settingList,
                             toSection: .normal)
        
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
extension ProfileViewController: BaseViewProtocol {
    
    func configureHierarchy() {
        
        view.addSubview(tableView)
    }
    
    func configureUI() {
        
        view.backgroundColor = .systemBackground
        tableView.register(ProfileTableViewCell.self,
                           forCellReuseIdentifier: ProfileTableViewCell.identifier)
        tableView.register(UITableViewCell.self,
                           forCellReuseIdentifier: UITableViewCell.identifier)
        tableView.separatorStyle = .singleLine
        tableView.delegate = self
    }
    
    func configureLayout() {
        
        tableView.snp.makeConstraints { make in
            make.directionalEdges.equalTo(view.safeAreaLayoutGuide)
        }
        
    }
    
}

private enum ProfileSection: Int, CaseIterable {
    case main
    case normal
}
