//
//  BlogCell.swift
//  Unsplash
//
//  Created by 안재영 on 2023/02/11.
//

import Kingfisher
import SnapKit
import UIKit


final class BlogCell: BaseCollectionViewCell {

  // MARK: - UI Components

  private let imageView: BaseImageView = {
    let view: BaseImageView = .init(image: nil)
    view.cornerType = .radius(5)
    view.contentMode = .scaleAspectFill
    return view
  }()

  private let titleLabel: UILabel = {
    let label: UILabel = .init()
    label.font = .boldSystemFont(ofSize: 16)
    return label
  }()

  private let writerLabel: UILabel = {
    let label: UILabel = .init()
    label.font = .systemFont(ofSize: 13)
    label.textColor = .white.withAlphaComponent(0.8)
    return label
  }()


  // MARK: - Layout

  override func addSubviews() {
    super.addSubviews()

    self.contentView.add(
      self.imageView,
      self.titleLabel,
      self.writerLabel
    )
  }

  override func setConstraints() {
    super.setConstraints()

    self.imageView.snp.makeConstraints { (make: ConstraintMaker) in
      make.top.left.right.equalToSuperview()
      make.height.equalToSuperview().multipliedBy(0.7)
    }

    self.titleLabel.snp.makeConstraints { (make: ConstraintMaker) in
      make.top.equalTo(self.imageView.snp.bottom).offset(10)
      make.left.equalToSuperview()
    }

    self.writerLabel.snp.makeConstraints { (make: ConstraintMaker) in
      make.top.equalTo(self.titleLabel.snp.bottom).offset(3)
      make.left.equalToSuperview()
    }
  }


  // MARK: - Configure

  func configure(blog: Blog) {
    self.imageView.image = blog.image
    self.titleLabel.text = blog.title
    self.writerLabel.text = blog.writer
  }
}
