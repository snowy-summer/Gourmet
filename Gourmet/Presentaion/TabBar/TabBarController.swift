//
//  TabBarController.swift
//  Gourmet
//
//  Created by 최승범 on 8/18/24.
//

import UIKit

final class TabBarController: UITabBarController {
    
    private var components = [UIViewController]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configure()
        
        addViewController(vc: HomeViewController(),
                          component: .home)
        addViewController(vc: PostListViewController(),
                          component: .recipe)
        addViewController(vc: ChoiceCategoryView(),
                          component: .edit)
        addViewController(vc: NormalPostListViewController(),
                          component: .community)
        addViewController(vc: NormalPostListViewController(),
                          component: .profile)
        
        setViewControllers(components,
                           animated: false)
    }
    
}

extension TabBarController {
    
    private func configure() {
        
        tabBar.tintColor = .black
        tabBar.unselectedItemTintColor = .lightGray
    }
    
    private func addViewController(vc: UIViewController,
                                   component: TabBarComponent) {
        
        let nc = UINavigationController(rootViewController: vc)
        nc.tabBarItem = UITabBarItem(title: nil,
                                     image: UIImage(systemName: component.icon),
                                     selectedImage: UIImage(systemName: component.icon))
        
        components.append(nc)
    }
}
