//
//  TabBarIcon.swift
//  Gourmet
//
//  Created by 최승범 on 8/29/24.
//

import Foundation

enum TabBarComponent: Int, CaseIterable {
    case home
    case recipe
    case edit
    case community
    case profile
    
    var icon: String {
        switch self {
        case .home:
            return "house.fill"
        case .recipe:
            return "book.closed.fill"
        case .edit:
            return "pencil"
        case .community:
            return "rectangle.3.group.bubble"
        case .profile:
            return "person.fill"
        }
    }
    
    var name: String {
        switch self {
        case .home:
            return "Home"
        case .recipe:
            return "Recipe"
        case .edit:
            return "Edit"
        case .community:
            return "Community"
        case .profile:
            return "Profile"
        }
    }
}
