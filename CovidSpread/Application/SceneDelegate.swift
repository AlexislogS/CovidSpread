//
//  SceneDelegate.swift
//  CovidSpread
//
//  Created by Alex Yatsenko on 07.06.2021.
//

import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {
  
  var window: UIWindow?
  
  func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
    window?.overrideUserInterfaceStyle = .light
  }
}
