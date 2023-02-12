//
//  SubContentCell.swift
//  Unsplash
//
//  Created by 안재영 on 2023/01/15.
//

import SnapKit
import UIKit


final class SubContentCell: BaseCollectionViewCell {

  // MARK: - UI Components

  private let titleLabel: UILabel = {
    let label: UILabel = .init()
    label.font = .systemFont(ofSize: 11)
    label.textColor = .white.withAlphaComponent(0.8)
    return label
  }()

  private let contentLabel: UILabel = {
    let label: UILabel = .init()
    label.font = .systemFont(ofSize: 12)
    label.numberOfLines = 0
    return label
  }()


  // MARK: - Properties

  var titleFont: UIFont? {
    get { return self.titleLabel.font }
    set { self.titleLabel.font = newValue }
  }

  var titleColor: UIColor? {
    get { return self.titleLabel.textColor }
    set { self.titleLabel.textColor = newValue }
  }

  var contentFont: UIFont? {
    get { return self.contentLabel.font }
    set { self.contentLabel.font = newValue }
  }

  var contentColor: UIColor? {
    get { return self.contentLabel.textColor }
    set { self.contentLabel.textColor = newValue }
  }


  // MARK: - Layout

  override func addSubviews() {
    super.addSubviews()

    self.contentView.add(
      self.titleLabel,
      self.contentLabel
    )
  }

  override func setConstraints() {
    super.setConstraints()

    self.titleLabel.snp.makeConstraints { (make: ConstraintMaker) in
      make.top.left.equalToSuperview()
    }

    self.contentLabel.snp.makeConstraints { (make: ConstraintMaker) in
      make.top.equalTo(self.titleLabel.snp.bottom)
      make.left.bottom.equalToSuperview()
    }
  }


  // MARK: - Configure

  func configure(title: String, content: String) {
    self.titleLabel.text = title
    self.contentLabel.text = content
  }
}
