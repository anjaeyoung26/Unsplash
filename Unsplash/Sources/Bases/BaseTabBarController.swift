//
//  BaseTabBarController.swift
//  Unsplash
//
//  Created by 안재영 on 2023/01/28.
//

import RxSwift
import UIKit


class BaseTabBarController: UITabBarController {

  // MARK: - Properties

  var selectedNavigationController: UINavigationController? {
    return self.selectedViewController as? UINavigationController
  }

  var hideTabBarDuration: TimeInterval = 0.6

  var showTabBarDuration: TimeInterval = 0.2

  var disposeBag: DisposeBag = .init()

  private var isTabBarHidden: Bool = false


  // MARK: - Initializers

  init() {
    super.init(nibName: nil, bundle: nil)

    self.setViewControllers()
    self.bind()
  }

  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }


  // MARK: - Layout

  func setViewControllers() {

  }


  // MARK: - Bind

  func bind() {
    
  }


  // MARK: - Methods

  func hideTabBarIfNeeded(animated: Bool) {
    if self.isTabBarHidden == false {
      self.isTabBarHidden = true

      let animations: () -> Void = {
        self.tabBar.center.y += self.tabBar.frame.height
        self.tabBar.alpha = 0
      }

      if animated {
        UIView.animate(withDuration: self.hideTabBarDuration, animations: animations)
      } else {
        animations()
      }
    }
  }

  func showTabBarIfNeeded(animated: Bool) {
    if self.isTabBarHidden == true {
      self.isTabBarHidden = false

      let animations: () -> Void = {
        self.tabBar.center.y -= self.tabBar.frame.height
        self.tabBar.alpha = 1
      }

      if animated {
        UIView.animate(withDuration: self.showTabBarDuration, animations: animations)
      } else {
        animations()
      }
    }
  }
}
