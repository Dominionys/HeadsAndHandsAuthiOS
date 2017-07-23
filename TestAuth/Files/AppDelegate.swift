//
//  AppDelegate.swift
//  TestAuth
//
//  Created by Denis Bezrukov on 20.07.17.
//  Copyright © 2017 Denis Bezrukov. All rights reserved.
//

import UIKit
import Look

@UIApplicationMain final class AppDelegate: UIResponder, UIApplicationDelegate {
  
  var window: UIWindow? = AppDelegate.getWindow()
  private static func getWindow() -> UIWindow {
    let window = UIWindow(frame: UIScreen.main.bounds)
    window.look.apply(Style.windowStyle)
    return window
  }
}

extension AppDelegate {
  
  typealias LaunchOptions = [UIApplicationLaunchOptionsKey: Any]?
  
  func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: LaunchOptions) -> Bool {
    window?.rootViewController = RootViewController()
    window?.makeKeyAndVisible()
    return true
  }
}

