//
//  MainTabBarPage.swift
//  SeSAC-Mission-Media
//
//  Created by 원태영 on 1/31/24.
//

import UIKit

enum MainTabBarPage: Int, CaseIterable {
  case home = 0
  case search
  case profile
  
  var index: Int {
    self.rawValue
  }
  
  var title: String {
    switch self {
      case .home:
        return "홈"
        
      case .search:
        return "검색"
        
      case .profile:
        return "프로필"
    }
  }
  
  var icon: UIImage? {
    switch self {
      case .home:
        return UIImage(systemName: "house")
        
      case .search:
        return UIImage(systemName: "magnifyingglass")
        
      case .profile:
        return UIImage(systemName: "person")
    }
  }
  
  var selectedIcon: UIImage? {
    switch self {
      case .home:
        return UIImage(systemName: "house.fill")
        
      case .search:
        return UIImage(systemName: "magnifyingglass")
        
      case .profile:
        return UIImage(systemName: "person.fill")
    }
  }
  
  var tabBarItem: UITabBarItem {
    return UITabBarItem(title: title, image: icon, tag: index).configured {
      $0.selectedImage = selectedIcon
    }
  }
}

