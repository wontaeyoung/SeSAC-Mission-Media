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
  
  var index: Int {
    self.rawValue
  }
  
  var title: String {
    switch self {
      case .home:
        return "홈"
        
      case .search:
        return "검색"
    }
  }
  
  var icon: UIImage? {
    switch self {
      case .home:
        return UIImage(systemName: "house")
        
      case .search:
        return UIImage(systemName: "magnifyingglass")
    }
  }
  
  var tabBarItem: UITabBarItem {
    return UITabBarItem(title: title, image: icon, tag: index)
  }
}

