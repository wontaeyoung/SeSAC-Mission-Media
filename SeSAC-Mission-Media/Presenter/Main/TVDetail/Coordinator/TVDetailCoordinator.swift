//
//  TVDetailCoordinator.swift
//  SeSAC-Mission-Media
//
//  Created by 원태영 on 2/5/24.
//

import UIKit

final class TVDetailCoordinator: Coordinator {
  
  weak var delegate: CoordinatorDelegate?
  var navigationController: UINavigationController
  var childCoordinators: [Coordinator]
  private var seriesID: Int? = nil
  
  init(_ navigationController: UINavigationController) {
    self.navigationController = navigationController
    self.childCoordinators = []
  }
  
  func start() {
    guard let seriesID else { return }
    
    showTVDetailViewController(with: seriesID)
  }
  
  func setData(with seriesID: Int) {
    self.seriesID = seriesID
  }
}

extension TVDetailCoordinator {
  func showTVDetailViewController(with seriesID: Int) {
    let viewController = TVDetailViewController(seriesID: seriesID)
    viewController.coordinator = self
    
    self.push(viewController)
  }
}

