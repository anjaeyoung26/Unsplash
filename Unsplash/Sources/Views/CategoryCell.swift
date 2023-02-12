//
//  CategoryCell.swift
//  Unsplash
//
//  Created by 안재영 on 2023/01/19.
//

import SnapKit
import UIKit


final class CategoryCell: BaseCollectionViewCell {

  // MARK: - UI Components

  private let imageView: BaseImageView = {
    let view: BaseImageView = .init(image: nil)
    view.contentMode = .scaleAspectFill
    return view
  }()

  private let blurView: UIView = {
    let view: UIView = .init()
    view.backgroundColor = .black.withAlphaComponent(0.3)
    return view
  }()

  private let titleLabel: UILabel = {
    let label: UILabel = .init()
    label.font = .boldSystemFont(ofSize: 14)
    label.textAlignment = .center
    label.numberOfLines = 0
    return label
  }()


  // MARK: - Properties

  var cornerRadius: CGFloat = 7

  var imageContentMode: UIView.ContentMode {
    get { return self.imageView.contentMode }
    set { self.imageView.contentMode = newValue }
  }

  var titleFont: UIFont? {
    get { return self.titleLabel.font }
    set { self.titleLabel.font = newValue }
  }


  // MARK: - Life Cycle

  override func layoutSubviews() {
    super.layoutSubviews()

    self.contentView.layer.cornerRadius = self.cornerRadius
    self.contentView.layer.masksToBounds = true
  }

  override func prepareForReuse() {
    super.prepareForReuse()

    self.imageView.image = nil
    self.titleLabel.text = nil
  }


  // MARK: - Layout

  override func addSubviews() {
    super.addSubviews()

    self.contentView.add(
      self.imageView,
      self.blurView,
      self.titleLabel
    )
  }

  override func setConstraints() {
    super.setConstraints()

    self.imageView.snp.makeConstraints { (make: ConstraintMaker) in
      make.edges.equalToSuperview()
    }

    self.blurView.snp.makeConstraints { (make: ConstraintMaker) in
      make.edges.equalToSuperview()
    }

    self.titleLabel.snp.makeConstraints { (make: ConstraintMaker) in
      make.edges.equalToSuperview().inset(10)
    }
  }


  // MARK: - Configure

  func configure(category: Category) {
    self.imageView.image = category.image
    self.titleLabel.text = category.title
  }
}
