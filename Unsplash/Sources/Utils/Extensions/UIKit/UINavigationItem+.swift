//
//  UINavigationItem+.swift
//  Unsplash
//
//  Created by 안재영 on 2023/01/13.
//

import UIKit


extension UINavigationItem {

  func setTitleView(
    title: String,
    titleFont: UIFont = .boldSystemFont(ofSize: 17),
    titleColor: UIColor = .label,
    subtitle: String? = nil,
    subtitleFont: UIFont = .systemFont(ofSize: 11),
    subtitleColor: UIColor = .secondaryLabel
  ) {
    let titleLabel: UILabel = .init()
    titleLabel.font = titleFont
    titleLabel.text = title
    titleLabel.textColor = titleColor
    titleLabel.textAlignment = .center
    titleLabel.sizeToFit()

    let stackView: UIStackView = .init(arrangedSubviews: [titleLabel])
    stackView.axis = .vertical
    stackView.distribution = .equalCentering

    if let subtitle = subtitle {
      let subtitleLabel: UILabel = .init()
      subtitleLabel.font = subtitleFont
      subtitleLabel.text = subtitle
      subtitleLabel.textColor = subtitleColor
      subtitleLabel.textAlignment = .center
      subtitleLabel.sizeToFit()

      let width: CGFloat = max(titleLabel.frame.width, subtitleLabel.frame.width)
      stackView.frame = CGRect(x: 0, y: 0, width: width, height: 35)
      stackView.addArrangedSubview(subtitleLabel)
    } else {
      stackView.frame = CGRect(x: 0, y: 0, width: titleLabel.frame.width, height: 35)
    }

    self.titleView = stackView
  }
}
