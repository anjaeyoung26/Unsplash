//
//  GradientView.swift
//  Unsplash
//
//  Created by 안재영 on 2022/12/29.
//

import UIKit


final class GradientView: UIView {

  // MARK: - Properties

  override class var layerClass: AnyClass {
    return CAGradientLayer.self
  }

  var gradientLayer: CAGradientLayer {
    return self.layer as! CAGradientLayer
  }
}
