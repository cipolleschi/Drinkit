//
//  AppDelegate.swift
//  DrinkIt
//
//  Created by Riccardo Cipolleschi on 10/12/2020.
//

import UIKit

@main
class AppDelegate: UIResponder, UIApplicationDelegate {

  var window: UIWindow?

  func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
    // Override point for customization after application launch.
    let window = UIWindow()
    let vc = DrinkVC()
    window.rootViewController = vc
    self.window  = window
    self.window?.makeKeyAndVisible()

    return true
  }

  func application(_ app: UIApplication, open url: URL, options: [UIApplication.OpenURLOptionsKey : Any] = [:]) -> Bool {
    return handleURL(url: url)
  }

  func handleURL(url: URL) -> Bool {
    UIView.setAnimationsEnabled(false)
    defer {
      UIView.setAnimationsEnabled(true)
    }
    let widgetComponents = NSURLComponents(url: url, resolvingAgainstBaseURL: true)

    if widgetComponents?.path?.contains("/add") ?? false {
      Storage.addWater(amount: 250)
      updateVC()
      return true
    } else if widgetComponents?.path?.contains("/rem") ?? false {
      Storage.remWater(amount: 250)
      updateVC()
      return true
    }
    return false
  }

  func updateVC() {
    guard let vc = (self.window?.rootViewController as? DrinkVC) else {
      return
    }
    vc.rootView.vm = DrinkVM(waterDrank: Storage.drankWater)
  }

}
