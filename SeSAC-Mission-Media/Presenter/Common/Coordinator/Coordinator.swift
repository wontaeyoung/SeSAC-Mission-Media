//
//  Coordinator.swift
//  SeSAC-Mission-Media
//
//  Created by 원태영 on 1/31/24.
//

import UIKit

protocol CoordinatorDelegate: AnyObject {
  
  func coordinatorDidEnd(_ childCoordinator: Coordinator)
}

protocol Coordinator: AnyObject {
  
  // MARK: - Property
  var navigationController: UINavigationController { get set }
  var delegate: CoordinatorDelegate? { get set }
  var childCoordinators: [Coordinator] { get set }
  
  
  // MARK: - Initialzier
  init(_ navigationController: UINavigationController)
  
  
  // MARK: - Method
  @MainActor func start()
  @MainActor func end()
  @MainActor func push(_ viewController: UIViewController, animation: Bool)
  @MainActor func pop(animation: Bool)
  @MainActor func popToRoot(animation: Bool)
  @MainActor func dismiss(animation: Bool)
  @MainActor func emptyOut()
  @MainActor func handle(error: AppError)
  @MainActor func showAlert(
    title: String,
    message: String,
    okTitle: String?,
    okStyle: UIAlertAction.Style,
    isCancelable: Bool,
    completion: (() -> Void)?
  )
}

// MARK: - View Navigation
extension Coordinator {
  
  @MainActor
  func end() {
    self.emptyOut()
    self.popToRoot()
    self.delegate?.coordinatorDidEnd(self)
  }
  
  func push(_ viewController: UIViewController, animation: Bool = true) {
    self.navigationController.pushViewController(viewController, animated: animation)
  }
  
  func pop(animation: Bool = true) {
    self.navigationController.popViewController(animated: animation)
  }
  
  func popToRoot(animation: Bool = true) {
    self.navigationController.popToRootViewController(animated: animation)
  }
  
  func present(_ viewController: UIViewController, style: UIModalPresentationStyle = .automatic, animation: Bool = true) {
    viewController.modalPresentationStyle = style
    self.navigationController.present(viewController, animated: animation)
  }
  
  func dismiss(animation: Bool = true) {
    self.navigationController.dismiss(animated: animation)
  }
  
  func emptyOut() {
    self.childCoordinators.removeAll()
  }
  
  func handle(error: AppError) {
    self.showErrorAlert(error: error)
  }
  
  func showAlert(
    title: String,
    message: String,
    okTitle: String? = nil,
    okStyle: UIAlertAction.Style = .default,
    isCancelable: Bool = true,
    completion: (() -> Void)? = nil
  ) {
    var alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
      .setAction(title: okTitle ?? "확인", style: okStyle, completion: completion)
      
    if isCancelable {
      alertController = alertController.setCancelAction()
    }
    
    self.present(alertController)
  }
  
  private func showErrorAlert(error: AppError) {
    let alertController = UIAlertController(
      title: error.alertDescription,
      message: nil,
      preferredStyle: .alert
    )
      .setAction(title: "확인", style: .default)
    
    GCD.main {
      self.present(alertController)
    }
  }
  
  func addChild(_ childCoordinator: Coordinator) {
    self.childCoordinators.append(childCoordinator)
  }
}
