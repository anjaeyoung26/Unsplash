//
//  SheetTransition.swift
//  Unsplash
//
//  Created by 안재영 on 2023/01/03.
//

import UIKit


final class SheetTransition: NSObject, UIViewControllerAnimatedTransitioning {

  // MARK: - Properties

  private var dismissAnimator: UIViewPropertyAnimator?

  private var presentAnimator: UIViewPropertyAnimator?

  var animationDuration: TimeInterval = 0.3

  var dampingRatio: CGFloat = 1

  var isPresenting: Bool = false


  // MARK: - Methods

  func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
    let interruptibleAnimator: UIViewImplicitlyAnimating = self.interruptibleAnimator(using: transitionContext)
    interruptibleAnimator.startAnimation()
  }

  func transitionDuration(
    using transitionContext: UIViewControllerContextTransitioning?
  ) -> TimeInterval {
    return self.animationDuration
  }

  func interruptibleAnimator(
    using transitionContext: UIViewControllerContextTransitioning
  ) -> UIViewImplicitlyAnimating {
    if self.isPresenting {
      return self.presentAnimator ?? self.presentationAnimator(transitionContext: transitionContext)
    } else {
      return self.dismissAnimator ?? self.dismissAnimator(transitionContext: transitionContext)
    }
  }

  private func presentationAnimator(
    transitionContext: UIViewControllerContextTransitioning
  ) -> UIViewImplicitlyAnimating {
    guard let toViewController: UIViewController = transitionContext.viewController(forKey: .to),
          let toView: UIView = transitionContext.view(forKey: .to) else {
      return UIViewPropertyAnimator()
    }

    toView.frame = transitionContext.finalFrame(for: toViewController)
    toView.frame.origin.y = transitionContext.containerView.frame.maxY
    transitionContext.containerView.addSubview(toView)

    let animator: UIViewPropertyAnimator = .init(
      duration: transitionDuration(using: transitionContext),
      dampingRatio: self.dampingRatio
    )

    let backgroundView = transitionContext.containerView.subviews.first
    backgroundView?.alpha = 0

    animator.addAnimations { toView.frame = transitionContext.finalFrame(for: toViewController) }
    animator.addAnimations { backgroundView?.alpha = 1 }
    animator.addCompletion { [weak self] _ in self?.presentAnimator = nil }
    animator.addCompletion { (position: UIViewAnimatingPosition) in
      if case .end = position {
        transitionContext.completeTransition(!transitionContext.transitionWasCancelled)
      } else {
        transitionContext.completeTransition(false)
      }
    }

    self.presentAnimator = animator
    return animator
  }

  private func dismissAnimator(
    transitionContext: UIViewControllerContextTransitioning
  ) -> UIViewImplicitlyAnimating {
    guard let fromView: UIView = transitionContext.view(forKey: .from) else {
      return UIViewPropertyAnimator()
    }

    let animator: UIViewPropertyAnimator = .init(
      duration: transitionDuration(using: transitionContext),
      dampingRatio: self.dampingRatio
    )

    let backgroundView = transitionContext.containerView.subviews.first

    animator.addAnimations { fromView.frame.origin.y = fromView.frame.maxY }
    animator.addAnimations { backgroundView?.alpha = 0 }
    animator.addCompletion { [weak self] _ in self?.dismissAnimator = nil }
    animator.addCompletion { (position: UIViewAnimatingPosition) in
      if case .end = position {
        transitionContext.completeTransition(!transitionContext.transitionWasCancelled)
        fromView.removeFromSuperview()
      } else {
        transitionContext.completeTransition(false)
      }
    }

    self.dismissAnimator = animator
    return animator
  }
}

