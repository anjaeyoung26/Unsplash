//
//  BaseImageView.swift
//  Unsplash
//
//  Created by 안재영 on 2023/02/15.
//

import Kingfisher
import UIKit


class BaseImageView: UIImageView {

  // MARK: - Defines

  enum CornerType {
    case circle
    case radius(CGFloat)
  }


  // MARK: - Properties

  var placeholder: UIImage?

  var options: KingfisherOptionsInfo?

  var cornerType: CornerType = .radius(0)


  // MARK: - Initializers

  override init(image: UIImage?) {
    super.init(image: image)

    self.layer.masksToBounds = true
  }

  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }


  // MARK: - Life Cycle

  override func layoutSubviews() {
    super.layoutSubviews()

    switch self.cornerType {
    case .circle:
      self.layer.cornerRadius = self.frame.height / 2
    case .radius(let radius):
      self.layer.cornerRadius = radius
    }
  }


  // MARK: - Configure

  func configure(url: URL) {
    self.kf.setImage(with: url, placeholder: self.placeholder, options: self.options)
  }
}
