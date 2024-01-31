//
//  MainTabBarCoordinator.swift
//  SeSAC-Mission-Media
//
//  Created by 원태영 on 1/31/24.
//

import UIKit

final class MainTabBarCoordinator: Coordinator {
  
  // MARK: - Property
  weak var delegate: CoordinatorDelegate?
  var navigationController: UINavigationController
  var childCoordinators: [Coordinator]
  var tabBarController: UITabBarController
  
  init(_ navigationController: UINavigationController) {
    self.navigationController = navigationController
    self.childCoordinators = []
    self.tabBarController = UITabBarController()
  }
  
  
  // MARK: - Method
  func start() {
    let rootNavigationControllers = MainTabBarPage.allCases.map { page in
      makeNavigationController(with: page)
    }
    
    configureTabBarController(with: rootNavigationControllers)
    self.push(tabBarController)
  }
  
  private func configureTabBarController(with controllers: [UINavigationController]) {
    tabBarController.configure {
      $0.setViewControllers(controllers, animated: false)
      $0.selectedIndex = MainTabBarPage.home.index
    }
  }
  
  @MainActor
  private func makeNavigationController(with page: MainTabBarPage) -> UINavigationController {
    return UINavigationController().configured {
      $0.tabBarItem = page.tabBarItem
      connectTabFlow(page: page, tabPageController: $0)
    }
  }
  
  @MainActor
  private func connectTabFlow(page: MainTabBarPage, tabPageController: UINavigationController) {
    switch page {
      case .home:
        let homeCoordinator = HomeCoordinator(tabPageController)
        homeCoordinator.start()
        self.addChild(homeCoordinator)
        
      case .search:
        print("ASD")
    }
  }
}
