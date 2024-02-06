//
//  SearchCoordinator.swift
//  SeSAC-Mission-Media
//
//  Created by 원태영 on 1/31/24.
//

import UIKit

final class SearchCoordinator: Coordinator {
  
  weak var delegate: CoordinatorDelegate?
  var navigationController: UINavigationController
  var childCoordinators: [Coordinator]
  
  init(_ navigationController: UINavigationController) {
    self.navigationController = navigationController
    self.childCoordinators = []
  }
  
  func start() {
    showSearchViewController()
  }
}

extension SearchCoordinator {
  func showSearchViewController() {
    let viewController = SearchViewController()
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
  
  @MainActor
  func combineActorDetailFlow(with actor: Actor) {
    let coordinator = ActorDetailCoordinator(self.navigationController)
    coordinator.setData(with: actor)
    coordinator.delegate = self
    self.addChild(coordinator)
    
    coordinator.start()
  }
}

extension SearchCoordinator: CoordinatorDelegate {
  
  func coordinatorDidEnd(_ childCoordinator: Coordinator) {
    self.emptyOut()
  }
}
