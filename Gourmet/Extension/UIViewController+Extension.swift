//
//  UIViewController.swift
//  Gourmet
//
//  Created by 최승범 on 8/19/24.
//

import UIKit

extension UIViewController {
    
    func resetViewController(vc: UIViewController) {
        
        let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene
        let sceneDelegate = windowScene?.delegate as? SceneDelegate
        let navigationController = UINavigationController(rootViewController: vc)
        sceneDelegate?.window?.rootViewController = navigationController
        sceneDelegate?.window?.makeKeyAndVisible()
    }
    
    func resetToTabBar() {
        let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene
        let sceneDelegate = windowScene?.delegate as? SceneDelegate
        sceneDelegate?.window?.rootViewController = TabBarController()
        sceneDelegate?.window?.makeKeyAndVisible()
    }
}
