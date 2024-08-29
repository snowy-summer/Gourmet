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

    func setUnderLine(color: UIColor, height: CGFloat = 1.0) {
        
        layer.sublayers?.filter { $0.name == "underlineLayer" }.forEach { $0.removeFromSuperlayer() }
        
        let underline = CALayer()
        underline.name = "underlineLayer"
        underline.backgroundColor = color.cgColor
        underline.frame = CGRect(x: 0,
                                 y: self.frame.height + 2,
                                 width: self.frame.width,
                                 height: height)
        underline.borderWidth = height
        layer.addSublayer(underline)
    }
    
}

