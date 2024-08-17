//
//  BaseViewProtocol.swift
//  Gourmet
//
//  Created by 최승범 on 8/17/24.
//

import Foundation

protocol BaseViewProtocol: AnyObject {
    
    func configureView()
    func configureNavigationBar()
    func configureHierarchy()
    func configureUI()
    func configureGestureAndButtonActions()
    func configureLayout()
    
}

extension BaseViewProtocol {
    
    func configureView() {
        configureNavigationBar()
        configureHierarchy()
        configureUI()
        configureLayout()
        configureGestureAndButtonActions()
    }

    func configureNavigationBar() {
        
    }
    
    func configureGestureAndButtonActions() {
        
    }
    
}
