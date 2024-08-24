//
//  UITextField+Extension.swift
//  Gourmet
//
//  Created by 최승범 on 8/17/24.
//

import UIKit

extension UITextField {
    
    func infoStyle(placeHolder: String) {
        
        let paddingView = UIView(frame: CGRect(x: 0,
                                               y: 0,
                                               width: 10,
                                               height: 0))
        
        layer.cornerRadius = 12
        placeholder = placeHolder
        backgroundColor = .lightGray.withAlphaComponent(0.25)
        leftView = paddingView
        leftViewMode = .always
    }
   
}

