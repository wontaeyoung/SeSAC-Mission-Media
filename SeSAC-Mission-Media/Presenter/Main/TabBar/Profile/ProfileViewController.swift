//
//  ProfileViewController.swift
//  SeSAC-Mission-Media
//
//  Created by 원태영 on 2/7/24.
//

import UIKit

enum ProfileItem: String, CaseIterable {
  case name = "이름"
  case nickname = "사용자 이름"
  case gender = "성별 대명사"
  case intro = "소개"
  case link = "링크"
  
  var title: String {
    return self.rawValue
  }
}

final class ProfileViewController: BaseViewController {
  
  // MARK: - UI
  
  
  // MARK: - Property
  weak var coordinator: ProfileCoordinator?
  
  // MARK: - Initializer
  
  
  // MARK: - Life Cycle
  override func setHierarchy() {
    
  }
  
  override func setAttribute() {
    view.backgroundColor = .systemRed
  }
  
  override func setConstraint() {
    
  }
  
  
  // MARK: - Method
  
  
}

