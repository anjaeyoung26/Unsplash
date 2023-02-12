//
//  UIView+AddWith.swift
//  Unsplash
//
//  Created by 안재영 on 2022/12/28.
//

import RxCocoa
import RxSwift
import UIKit


extension UIView {

  func add(_ subviews: [UIView]) {
    subviews.forEach { (subview: UIView) in
      self.addSubview(subview)
    }
  }

  func add(_ subviews: UIView...) {
    self.add(subviews)
  }

  func with(_ subviews: UIView...) -> Self {
    self.add(subviews)
    return self
  }

  func with(_ subviews: [UIView]) -> Self {
    self.add(subviews)
    return self
  }

  func with(_ subviews: [UIView]...) -> Self {
    return self.with(subviews.flatMap { (subviews: [UIView]) -> [UIView] in subviews })
  }
}


// MARK: - Border

extension UIView {

  func addDashBorder(
    fillColor: UIColor,
    strokeColor: UIColor,
    cornerRadius: CGFloat,
    lineWidth: CGFloat,
    lineDashPattern: [NSNumber]
  ) {
    let frameSize: CGSize = self.frame.size
    let rect: CGRect = .init(
      x: 0,
      y: 0,
      width: frameSize.width,
      height: frameSize.height
    )

    let path: UIBezierPath = .init(roundedRect: rect, cornerRadius: cornerRadius)
    let position: CGPoint = .init(x: frameSize.width / 2, y: frameSize.height / 2)
    let shapeLayer: CAShapeLayer = .init()
    shapeLayer.path = path.cgPath
    shapeLayer.bounds = rect
    shapeLayer.position = position
    shapeLayer.fillColor = fillColor.cgColor
    shapeLayer.strokeColor = strokeColor.cgColor
    shapeLayer.lineJoin = .round
    shapeLayer.lineWidth = lineWidth
    shapeLayer.lineDashPattern = lineDashPattern

    self.layer.addSublayer(shapeLayer)
  }
}
