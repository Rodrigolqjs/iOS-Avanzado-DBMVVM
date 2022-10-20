//
//  SceneDelegate.swift
//  Práctica Fundamentos iOS
//
//  Created by Juan Cruz Guidi on 24/6/22.
//

import UIKit
import KeychainSwift

final class SceneDelegate: UIResponder, UIWindowSceneDelegate {
  
  var window: UIWindow?
  
  func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
    guard let scene = (scene as? UIWindowScene) else { return }
    let window = UIWindow(windowScene: scene)
    let navigationController = UINavigationController()
    navigationController.navigationBar.isHidden = true
    
    let viewController: UIViewController
    let keyChain = KeychainSwift()
      
      if keyChain.get("KCToken") != nil {
          viewController = TableViewController()
      } else {
          viewController = LoginViewController()
      }
      
    navigationController.setViewControllers([viewController], animated: false)
    
    window.rootViewController = navigationController
    window.makeKeyAndVisible()
    
    self.window = window
  }
}
