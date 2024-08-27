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
                          selectImage: UIImage(systemName: "star"),
                          unselectImage: UIImage(systemName: "star.fill"))
        addViewController(vc: PostListViewController(),
                          selectImage: UIImage(systemName: "star"),
                          unselectImage: UIImage(systemName: "star.fill"))
        addViewController(vc: NormalPostListViewController(),
                          selectImage: UIImage(systemName: "rectangle.3.group.bubble"),
                          unselectImage: UIImage(systemName: "rectangle.3.group.bubble"))
        
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
                                   selectImage: UIImage?,
                                   unselectImage: UIImage?) {
        
        let nc = UINavigationController(rootViewController: vc)
        nc.tabBarItem = UITabBarItem(title: nil,
                                     image: unselectImage,
                                     selectedImage: selectImage)
        
        components.append(nc)
    }
}
