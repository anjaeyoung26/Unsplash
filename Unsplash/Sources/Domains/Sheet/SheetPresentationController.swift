//
//  SheetPresentationController.swift
//  Unsplash
//
//  Created by 안재영 on 2023/01/03.
//

import UIKit


final class SheetPresentationController: UIPresentationController {

  // MARK: - UI Components

  private lazy var backgroundView: UIView = {
    let tapRecognizer: UITapGestureRecognizer = .init(
      target: self,
      action: #selector(self.didTapBackgroundView)
    )
    let view: UIView = .init()
    view.addGestureRecognizer(tapRecognizer)
    view.backgroundColor = self.backgroundColor
    view.alpha = 0
    return view
  }()


  // MARK: - Properties

  override var frameOfPresentedViewInContainerView: CGRect {
    guard let containerView = self.containerView,
          let presentedView = self.presentedView else {
      return super.frameOfPresentedViewInContainerView
    }

    let fittingSize: CGSize = .init(
      width: containerView.bounds.width,
      height: UIView.layoutFittingCompressedSize.height
    )

    let presentedViewHeight: CGFloat = presentedView.systemLayoutSizeFitting(
      fittingSize,
      withHorizontalFittingPriority: .required,
      verticalFittingPriority: .defaultLow
    ).height

    let adjustedHeight: CGFloat = presentedViewHeight + containerView.safeAreaInsets.bottom
    let targetSize: CGSize = .init(width: containerView.frame.width, height: adjustedHeight)
    let targetOrigin: CGPoint = .init(x: .zero, y: containerView.frame.maxY - targetSize.height)

    return .init(origin: targetOrigin, size: targetSize)
  }

  private var transitionDelegate: SheetTransitioningController? {
    return self.presentedViewController.transitioningDelegate as? SheetTransitioningController
  }

  var backgroundColor: UIColor = .black.withAlphaComponent(0.5)

  var cornerRadius: CGFloat = 5


  // MARK: - Life Cycle

  override func presentationTransitionWillBegin() {
    super.presentationTransitionWillBegin()

    self.containerView?.addSubview(self.backgroundView)
    self.presentedView?.layer.cornerRadius = self.cornerRadius
    self.presentedView?.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
  }

  override func dismissalTransitionDidEnd(_ completed: Bool) {
    super.dismissalTransitionWillBegin()

    self.backgroundView.removeFromSuperview()
    self.presentedView?.layer.cornerRadius = 0
  }


  // MARK: - Layout

  override func containerViewDidLayoutSubviews() {
    super.containerViewDidLayoutSubviews()

    if let containerView = self.containerView {
      self.backgroundView.frame = containerView.bounds
    }
  }


  // MARK: - Selector

  @objc
  private func didTapBackgroundView() {
    self.presentedViewController.dismiss(animated: true)
  }
}

