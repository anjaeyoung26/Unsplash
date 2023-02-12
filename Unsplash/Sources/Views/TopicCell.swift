//
//  TopicCell.swift
//  Unsplash
//
//  Created by 안재영 on 2023/02/10.
//

import Kingfisher
import SnapKit
import UIKit


final class TopicCell: BaseCollectionViewCell {

  // MARK: - UI Components

  private let imageView: BaseImageView = {
    let view: BaseImageView = .init(image: nil)
    view.contentMode = .scaleAspectFill
    view.options = [
      .transition(.fade(0.5)),
      .forceTransition
    ]
    return view
  }()

  private let blurView: UIView = {
    let view: UIView = .init()
    view.backgroundColor = .black.withAlphaComponent(0.5)
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

  func configure(topic: Topic) {
    if let blurHash: String = topic.coverPhoto.blurHash {
      self.imageView.placeholder = .init(
        blurHash: blurHash,
        size: .init(width: 40, height: 40)
      )
    }

    if let url: URL = .init(string: topic.coverPhoto.urls.small) {
      self.imageView.configure(url: url)
    }

    self.titleLabel.text = topic.title
  }
}
