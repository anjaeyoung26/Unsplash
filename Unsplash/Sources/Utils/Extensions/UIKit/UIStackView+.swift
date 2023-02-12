//
//  UIStackView+.swift
//  Unsplash
//
//  Created by 안재영 on 2023/01/13.
//

import UIKit


extension UIStackView {

  func addArranged(_ subviews: [UIView]) {
    subviews.forEach { (view: UIView) in self.addArrangedSubview(view) }
  }

  func withArranged(_ subviews: [UIView]) -> Self {
    self.addArranged(subviews)
    return self
  }
}
