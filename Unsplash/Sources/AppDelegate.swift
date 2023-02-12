//
//  AppDelegate.swift
//  Unsplash
//
//  Created by 안재영 on 2022/12/24.
//

import UIKit


@main
class AppDelegate: UIResponder, UIApplicationDelegate {

  // MARK: - Properties

  var window: UIWindow?


  // MARK: - Life Cycle

  func application(
    _ application: UIApplication,
    didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
  ) -> Bool {
    let rootViewController: SplashViewController = AppAssembler.resolve(SplashViewController.self)
    let window: UIWindow = .init(frame: UIScreen.main.bounds)
    window.rootViewController = rootViewController
    window.makeKeyAndVisible()
    self.window = window

    let tabBarAppearance: UITabBarAppearance = .init()
    tabBarAppearance.configureWithOpaqueBackground()
    tabBarAppearance.backgroundColor = .init(
      red: 17/255,
      green: 17/255,
      blue: 17/255,
      alpha: 1.0
    )
    tabBarAppearance.shadowImage = nil
    tabBarAppearance.shadowColor = nil
    UITabBar.appearance().tintColor = .white
    UITabBar.appearance().standardAppearance = tabBarAppearance
    UITabBar.appearance().scrollEdgeAppearance = tabBarAppearance
    UINavigationBar.appearance().tintColor = .white

    RxImagePickerDelegateProxy.register { (
      imagePickerController: UIImagePickerController
    ) -> RxImagePickerDelegateProxy in
      return .init(imagePickerController: imagePickerController)
    }

    return true
  }
}

