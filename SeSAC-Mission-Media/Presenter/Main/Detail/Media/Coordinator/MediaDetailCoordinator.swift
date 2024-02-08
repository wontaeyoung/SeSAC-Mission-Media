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
  
  private var media: Media? = nil
  
  init(_ navigationController: UINavigationController) {
    self.navigationController = navigationController
    self.childCoordinators = []
  }
  
  func start() {
    guard let media else { return }
    
    showMediaDetailViewController(with: media)
  }
  
  func setData(with media: Media) {
    self.media = media
  }
}

extension MediaDetailCoordinator {
  func showMediaDetailViewController(with media: Media) {
    let viewController = MediaDetailViewController(media: media)
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
  
  func showTrailerViewController(with media: Media) {
    let viewController = TrailerViewController(media: media)
    viewController.coordinator = self
    
    self.push(viewController)
  }
}

extension MediaDetailCoordinator: CoordinatorDelegate {
  
  @MainActor
  func coordinatorDidEnd(_ childCoordinator: Coordinator) {
    self.end()
    delegate?.coordinatorDidEnd(self)
  }
}

