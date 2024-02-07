//
//  ProfileCoordinator.swift
//  SeSAC-Mission-Media
//
//  Created by 원태영 on 2/7/24.
//

import UIKit

final class ProfileCoordinator: Coordinator {
  
  weak var delegate: CoordinatorDelegate?
  var navigationController: UINavigationController
  var childCoordinators: [Coordinator]
  
  init(_ navigationController: UINavigationController) {
    self.navigationController = navigationController
    self.childCoordinators = []
  }
  
  func start() {
    showProfileViewController()
  }
}

extension ProfileCoordinator {
  private func showProfileViewController() {
    let viewController = ProfileViewController()
    viewController.coordinator = self
    
    self.push(viewController)
  }
}
