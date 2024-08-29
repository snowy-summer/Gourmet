//
//  IconComponet.swift
//  Gourmet
//
//  Created by 최승범 on 8/29/24.
//

import UIKit

enum IconConmponent {
    case like
    case comments
    case time
    case grade
    case timer
    case difficultyLevel
    
    var iconName: String {
        switch self {
        case .like:
            return "heart.fill"
        case .comments:
            return "bubble.fill"
        case .time:
            return "clock.fill"
        case .grade:
            return "star.fill"
        case .timer:
            return "timer"
        case .difficultyLevel:
            return "flame.fill"
        }
    }
    
    var color: UIColor {
        switch self {
        case .like:
            return .bittersweet
        case .comments:
            return .mantis
        case .time:
            return .time
        case .grade:
            return .accent
        case .timer:
            return .accent
        case .difficultyLevel:
            return .red
        }
    }
}
