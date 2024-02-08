//
//  ActorDetailCoordinator.swift
//  SeSAC-Mission-Media
//
//  Created by 원태영 on 2/6/24.
//

import UIKit

final class ActorDetailCoordinator: Coordinator {
  
  weak var delegate: CoordinatorDelegate?
  var navigationController: UINavigationController
  var childCoordinators: [Coordinator]
  private var actor: Actor? = nil
  
  init(_ navigationController: UINavigationController) {
    self.navigationController = navigationController
    self.childCoordinators = []
  }
  
  func start() {
    guard let actor else { return }
    
    showActorDetailViewController(with: actor)
  }
  
  func setData(with actor: Actor) {
    self.actor = actor
  }
}

extension ActorDetailCoordinator {
  func showActorDetailViewController(with actor: Actor) {
    let viewController = ActorDetailViewController(actor: actor)
    viewController.coordinator = self
    
    self.push(viewController)
  }
  
  @MainActor
  func combineMediaDetailFlow(with media: Media) {
    let coordinator = MediaDetailCoordinator(self.navigationController)
    coordinator.setData(with: media)
    coordinator.delegate = self
    self.addChild(coordinator)
    
    coordinator.start()
  }
}

extension ActorDetailCoordinator: CoordinatorDelegate {
  
  @MainActor
  func coordinatorDidEnd(_ childCoordinator: Coordinator) {
    self.end()
  }
}
