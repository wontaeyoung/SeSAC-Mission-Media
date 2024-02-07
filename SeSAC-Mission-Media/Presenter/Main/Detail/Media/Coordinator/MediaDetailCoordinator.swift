//
//  MediaDetailCoordinator.swift
//  SeSAC-Mission-Media
//
//  Created by 원태영 on 2/5/24.
//

import UIKit

final class MediaDetailCoordinator: Coordinator {
  
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
    
    showMediaDetailViewController(with: seriesID)
  }
  
  func setData(with seriesID: Int) {
    self.seriesID = seriesID
  }
}

extension MediaDetailCoordinator {
  func showMediaDetailViewController(with seriesID: Int) {
    let viewController = MediaDetailViewController(seriesID: seriesID)
    viewController.coordinator = self
    
    self.push(viewController)
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

extension MediaDetailCoordinator: CoordinatorDelegate {
  
  @MainActor
  func coordinatorDidEnd(_ childCoordinator: Coordinator) {
    self.end()
    delegate?.coordinatorDidEnd(self)
  }
}

