//
//  EditRecipeSection.swift
//  Gourmet
//
//  Created by 최승범 on 8/28/24.
//

import UIKit

enum EditRecipeSection: Int, CaseIterable {
    case title
    case category
    case ingredientAdd
    case ingredientContent
    case contentAdd
    case content
    case time
    case difficulty
    case price
    
    var headerTitle: String {
        switch self {
        case .title:
            return "제목"
            
        case .category:
            return "카테고리"
            
        case .ingredientAdd:
            return "재료"
            
        case .contentAdd:
            return "내용"
            
        case .time:
            return "시간"
            
        case .difficulty:
            return "난이도"
            
        default:
            return ""
        }
    }
    
    var defaultValue: String {
        switch self {
        case .time:
            return "60 min"
            
        case .difficulty:
            return "보통"
            
        default:
            return ""
        }
    }
    
    var iconName: String {
        switch self {
        case .category:
            return "fork.knife"
        case .ingredientAdd:
            return "carrot.fill"
        case .contentAdd:
            return "book.pages.fill"
        case .time:
            return "clock"
        case .difficulty:
            return "flame.fill"
        default:
            return ""
        }
    }
    
    var iconColor: UIColor {
        switch self {
        case .category:
            return .black
        case .ingredientAdd:
            return .orange
        case .contentAdd:
            return .mantis
        case .time:
            return .time
        case .difficulty:
            return .red
        default:
            return .lightGray
        }
    }
    
    func layoutSection(with layoutEnvironment: NSCollectionLayoutEnvironment) -> NSCollectionLayoutSection {
        
        switch self {
        case .title:
            var configuration = UICollectionLayoutListConfiguration(appearance: .insetGrouped)
            configuration.backgroundColor = .clear
            let section = NSCollectionLayoutSection.list(using: configuration,
                                                         layoutEnvironment: layoutEnvironment)
            return section
            
        case .category:
            let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0),
                                                  heightDimension: .fractionalHeight(1.0))
            let item = NSCollectionLayoutItem(layoutSize: itemSize)
            
            
            let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0),
                                                   heightDimension: .estimated(200))
            let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize,
                                                           subitems: [item])
            let section = NSCollectionLayoutSection(group: group)
            
            section.contentInsets = NSDirectionalEdgeInsets(top: 8,
                                                            leading: 20,
                                                            bottom: 8,
                                                            trailing: 20)
            return section
            
        case .ingredientAdd:
            let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0),
                                                  heightDimension: .fractionalHeight(1.0))
            let item = NSCollectionLayoutItem(layoutSize: itemSize)
            
            
            let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0),
                                                   heightDimension: .estimated(240))
            let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize,
                                                           subitems: [item])
            let section = NSCollectionLayoutSection(group: group)
            
            section.contentInsets = NSDirectionalEdgeInsets(top: 8,
                                                            leading: 20,
                                                            bottom: 8,
                                                            trailing: 20)
            return section
            
        case .ingredientContent, .content:
            var configuration = UICollectionLayoutListConfiguration(appearance: .insetGrouped)
            configuration.backgroundColor = .clear
            let section = NSCollectionLayoutSection.list(using: configuration,
                                                         layoutEnvironment: layoutEnvironment)
            
            
            section.contentInsets = NSDirectionalEdgeInsets(top: 8,
                                                            leading: 20,
                                                            bottom: 8,
                                                            trailing: 20)
            return section
            
        case .contentAdd:
            let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0),
                                                  heightDimension: .fractionalHeight(1.0))
            let item = NSCollectionLayoutItem(layoutSize: itemSize)
            
            
            let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0),
                                                   heightDimension: .estimated(300))
            let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize,
                                                           subitems: [item])
            let section = NSCollectionLayoutSection(group: group)
            
            section.contentInsets = NSDirectionalEdgeInsets(top: 8,
                                                            leading: 20,
                                                            bottom: 8,
                                                            trailing: 20)
            
            return section
            
        case .time, .difficulty:
            let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0),
                                                  heightDimension: .fractionalHeight(1.0))
            let item = NSCollectionLayoutItem(layoutSize: itemSize)
            
            
            let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0),
                                                   heightDimension: .absolute(60))
            let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize,
                                                           subitems: [item])
            
            let section = NSCollectionLayoutSection(group: group)
            
            section.contentInsets = NSDirectionalEdgeInsets(top: 0,
                                                            leading: 20,
                                                            bottom: 8,
                                                            trailing: 20)
            
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
                                                            leading: 20,
                                                            bottom: 8,
                                                            trailing: 20)
            
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
