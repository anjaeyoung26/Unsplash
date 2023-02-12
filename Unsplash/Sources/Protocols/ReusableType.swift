//
//  ReusableType.swift
//  Unsplash
//
//  Created by 안재영 on 2022/12/28.
//

import Foundation
import UIKit


protocol ReusableType {

  // MARK: - Properties

  static var classType: AnyClass? { get }

  static var identifier: String { get }
}


// MARK: - ReusableType Extension

extension ReusableType {

  static var identifier: String {
    return .init(describing: self)
  }
}


// MARK: - ReusableType Extension (UIView)

extension ReusableType where Self: UIView {

  static var classType: AnyClass? {
    return Self.self
  }
}
