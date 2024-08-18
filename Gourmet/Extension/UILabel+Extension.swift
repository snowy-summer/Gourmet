//
//  UILabel+Extension.swift
//  Gourmet
//
//  Created by 최승범 on 8/17/24.
//

import UIKit

extension UIButton {
    
    func normalStyle(title: String,
                     back: UIColor = .white,
                     fore: UIColor = .black,
                     fontSize: CGFloat = 18) {
        var customConfiguration = UIButton.Configuration.filled()
        var titleAttribute = AttributeContainer()
        titleAttribute.font = .systemFont(ofSize: fontSize,
                                          weight: .bold)
        customConfiguration.titleAlignment = .center
        customConfiguration.baseBackgroundColor = back
        customConfiguration.baseForegroundColor = fore
        customConfiguration.cornerStyle = .large
        customConfiguration.attributedTitle = AttributedString(title,
                                                               attributes: titleAttribute)
        var backgroundConfig = UIBackgroundConfiguration.clear()
        backgroundConfig.strokeColor = .main
        backgroundConfig.strokeWidth = 1
        
        customConfiguration.background = backgroundConfig
        
        configuration = customConfiguration
    }
}
