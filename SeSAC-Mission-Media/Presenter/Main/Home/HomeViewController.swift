//
//  HomeViewController.swift
//  SeSAC-Mission-Media
//
//  Created by 원태영 on 1/30/24.
//

import UIKit
import SnapKit

enum TVCollection: Int, CaseIterable {
  case trend = 0
  case topRated
  case popular
  
  var title: String {
    switch self {
      case .trend:
        return "트렌디한 TV 프로그램"
        
      case .topRated:
        return "별점이 높은 TV 프로그램"
        
      case .popular:
        return "인기있는 TV 프로그램"
    }
  }
}

