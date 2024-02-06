//
//  HomeCoordinator.swift
//  SeSAC-Mission-Media
//
//  Created by 원태영 on 1/31/24.
//

import UIKit

final class HomeCoordinator: Coordinator {
  
  weak var delegate: CoordinatorDelegate?
  var navigationController: UINavigationController
  var childCoordinators: [Coordinator]
  
  init(_ navigationController: UINavigationController) {
    self.navigationController = navigationController
    self.childCoordinators = []
  }
  
  func start() {
    showHomeViewController()
  }
}

extension HomeCoordinator {
  func showHomeViewController() {
    let viewController = HomeViewController()
    viewController.coordinator = self
    
    self.push(viewController, animation: false)
  }
  
  @MainActor
  func combineMediaDetailFlow(with seriesID: Int) {
    let coordinator = MediaDetailCoordinator(self.navigationController)
    coordinator.setData(with: seriesID)
    coordinator.delegate = self
    self.addChild(coordinator)
    
    coordinator.start()
  }
}

extension HomeCoordinator: CoordinatorDelegate {
  
  func coordinatorDidEnd(_ childCoordinator: Coordinator) {
    self.emptyOut()
  }
}
