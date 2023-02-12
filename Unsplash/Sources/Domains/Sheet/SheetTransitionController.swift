//
//  SheetTransitionController.swift
//  Unsplash
//
//  Created by 안재영 on 2023/01/03.
//

import UIKit


final class SheetTransitioningController: NSObject, UIViewControllerTransitioningDelegate {

  // MARK: - Properties

  let transition = SheetTransition()


  // MARK: - Methods

  func presentationController(
    forPresented presented: UIViewController,
    presenting: UIViewController?,
    source: UIViewController
  ) -> UIPresentationController? {
    return SheetPresentationController(
      presentedViewController: presented,
      presenting: presenting
    )
  }

  func animationController(
    forPresented presented: UIViewController,
    presenting: UIViewController,
    source: UIViewController
  ) -> UIViewControllerAnimatedTransitioning? {
    self.transition.isPresenting = true
    return self.transition
  }

  func animationController(
    forDismissed dismissed: UIViewController
  ) -> UIViewControllerAnimatedTransitioning? {
    self.transition.isPresenting = false
    return self.transition
  }
}

