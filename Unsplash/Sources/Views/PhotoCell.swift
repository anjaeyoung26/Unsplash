//
//  PhotoCell.swift
//  Unsplash
//
//  Created by 안재영 on 2023/01/03.
//

import Kingfisher
import SnapKit
import UIKit


final class PhotoCell: BaseCollectionViewCell {

  // MARK: - UI Components

  private let imageView: BaseImageView = {
    let view: BaseImageView = .init(image: nil)
    view.options = [
      .transition(.fade(0.5)),
      .cacheMemoryOnly
    ]
    return view
  }()

  private let blurView: UIView = {
    let view: UIView = .init()
    view.backgroundColor = .black.withAlphaComponent(0.12)
    return view
  }()

  private let ownerLabel: UILabel = {
    let label: UILabel = .init()
    label.font = .boldSystemFont(ofSize: 12)
    label.numberOfLines = 2
    return label
  }()


  // MARK: - Properties

  var cornerRadius: CGFloat = 0

  var imageContentMode: UIView.ContentMode {
    get { return self.imageView.contentMode }
    set { self.imageView.contentMode = newValue }
  }

  var ownerFont: UIFont? {
    get { return self.ownerLabel.font }
    set { self.ownerLabel.font = newValue }
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
    self.ownerLabel.text = nil
  }


  // MARK: - Layout

  override func addSubviews() {
    super.addSubviews()

    self.contentView.add(
      self.imageView,
      self.blurView,
      self.ownerLabel
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

    self.ownerLabel.snp.makeConstraints { (make: ConstraintMaker) in
      make.left.bottom.equalToSuperview().inset(10)
    }
  }


  // MARK: - Configure

  func configure(photo: Photo, showOwner: Bool = false) {
    if let blurHash: String = photo.blurHash {
      self.imageView.placeholder = .init(
        blurHash: blurHash,
        size: .init(width: 32, height: 32)
      )
    }

    if let url: URL = .init(string: photo.urls.small) {
      self.imageView.configure(url: url)
    }

    let attributedString: NSMutableAttributedString = .init(string: photo.user.name)

    if let _ = photo.sponsorship {
      attributedString.append(.init(
        string: "\nSponsored",
        attributes: [
          .foregroundColor: UIColor.lightGray,
          .font: UIFont.systemFont(ofSize: 12)
        ]
      ))
    }

    self.ownerLabel.isHidden = !showOwner
    self.ownerLabel.attributedText = attributedString
  }
}
