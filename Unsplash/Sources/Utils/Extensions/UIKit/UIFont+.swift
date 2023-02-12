//
//  UIFont+.swift
//  Unsplash
//
//  Created by 안재영 on 2022/12/30.
//

import UIKit


extension UIFont {

  // MARK: - Pretendard

  static let pretendard: Pretendard = .init()

  public struct Pretendard {

    // MARK: - Methods

    func bold(_ size: CGFloat) -> UIFont {
      return .init(name: "Pretendard-Bold", size: size) ?? .systemFont(ofSize: size, weight: .bold)
    }

    func semibold(_ size: CGFloat) -> UIFont {
      return .init(name: "Pretendard-SemiBold", size: size) ?? .systemFont(ofSize: size, weight: .semibold)
    }

    func medium(_ size: CGFloat) -> UIFont {
      return .init(name: "Pretendard-Medium", size: size) ?? .systemFont(ofSize: size, weight: .medium)
    }

    func regular(_ size: CGFloat) -> UIFont {
      return .init(name: "Pretendard-Regular", size: size) ?? .systemFont(ofSize: size, weight: .regular
      )
    }
  }
}
