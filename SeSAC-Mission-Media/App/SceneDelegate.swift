//
//  SceneDelegate.swift
//  SeSAC-Mission-Movie
//
//  Created by 원태영 on 1/30/24.
//

import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {
  
  var window: UIWindow?
  var coordinator: AppCoordinator?
  
  func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
    
    guard let scene = (scene as? UIWindowScene) else { return }
    
    
    let rootViewController = UINavigationController()
    rootViewController.navigationBar.isHidden = true
    self.coordinator = AppCoordinator(rootViewController)
    
    self.window = UIWindow(windowScene: scene)
    window?.rootViewController = rootViewController
    window?.makeKeyAndVisible()
    
    coordinator?.start()
  }
}
