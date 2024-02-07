//
//  ProfileView.swift
//  SeSAC-Mission-Media
//
//  Created by 원태영 on 2/7/24.
//

import UIKit
import SnapKit

final class ProfileView: BaseView {
  
  
  // MARK: - UI
  private let profileImageButton = UIButton().configured { button in
    button.configuration = .plain().configured {
      $0.image = UIImage(systemName: "person.circle.fill")
      $0.cornerStyle = .capsule
    }
  }
  
  private let tableView = UITableView().configured {
    $0.register(
      ProfileItemTableViewCell.self,
      forCellReuseIdentifier: ProfileItemTableViewCell.identifier
    )
  }
  
  
  // MARK: - Life Cycle
  override func setHierarchy() {
    self.addSubviews(profileImageButton, tableView)
  }
  
  override func setConstraint() {
    profileImageButton.snp.makeConstraints {
      $0.top.equalTo(self.safeAreaLayoutGuide).offset(24)
      $0.centerX.equalToSuperview()
      $0.size.equalTo(UIScreen.main.bounds.width * 0.2)
    }
    
    tableView.snp.makeConstraints {
      $0.top.equalTo(profileImageButton.snp.bottom).offset(24)
      $0.horizontalEdges.bottom.equalTo(self.safeAreaLayoutGuide)
    }
  }
  
  // MARK: - Method
  func setDelegate(with controller: some TableControllable) {
    self.tableView.delegate = controller
    self.tableView.dataSource = controller
  }
}

