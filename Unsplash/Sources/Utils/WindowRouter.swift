//
//  WindowRouter.swift
//  Unsplash
//
//  Created by 안재영 on 2023/01/19.
//

import UIKit


final class WindowRouter {

  // MARK: - Properties

  static let window: UIWindow? = UIApplication.shared.windows.first

  static var rootViewController: UIViewController? {
    return self.window?.rootViewController
  }

  static var tabBarController: TabBarController? {
    return self.rootViewController as? TabBarController
  }
}
