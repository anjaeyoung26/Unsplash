//
//  CollectionCell.swift
//  Unsplash
//
//  Created by 안재영 on 2023/01/25.
//

import Kingfisher
import SnapKit
import UIKit


final class CollectionCell: BaseCollectionViewCell {

  // MARK: - UI Components

  private let coverImageView: BaseImageView = {
    let view: BaseImageView = .init(image: nil)
    view.contentMode = .scaleAspectFill
    return view
  }()

  private let titleLabel: UILabel = {
    let label: UILabel = .init()
    label.font = .boldSystemFont(ofSize: 15)
    return label
  }()

  private let descriptionLabel: UILabel = {
    let label: UILabel = .init()
    label.font = .systemFont(ofSize: 12)
    label.textColor = .white.withAlphaComponent(0.8)
    return label
  }()


  // MARK: - Properties

  var cornerRadius: CGFloat = 5


  // MARK: - Initializers

  override init(frame: CGRect) {
    super.init(frame: frame)

    self.backgroundColor = .init(red: 28/255, green: 28/255, blue: 28/255, alpha: 1.0)
  }

  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }


  // MARK: - Life Cycle

  override func layoutSubviews() {
    super.layoutSubviews()

    self.layer.cornerRadius = self.cornerRadius
    self.layer.masksToBounds = true
  }

  override func prepareForReuse() {
    super.prepareForReuse()

    self.titleLabel.text = nil
    self.descriptionLabel.text = nil
    self.coverImageView.image = nil
  }


  // MARK: - Layout

  override func addSubviews() {
    super.addSubviews()

    self.contentView.add(
      self.coverImageView,
      self.titleLabel,
      self.descriptionLabel
    )
  }

  override func setConstraints() {
    super.setConstraints()

    self.coverImageView.snp.makeConstraints { (make: ConstraintMaker) in
      make.top.left.right.equalToSuperview()
      make.bottom.equalTo(self.titleLabel.snp.top).offset(-12)
    }

    self.titleLabel.snp.makeConstraints { (make: ConstraintMaker) in
      make.left.right.equalToSuperview().inset(12)
      make.bottom.equalTo(self.descriptionLabel.snp.top).offset(-3)
    }

    self.descriptionLabel.snp.makeConstraints { (make: ConstraintMaker) in
      make.left.right.bottom.equalToSuperview().inset(12)
    }
  }


  // MARK: - Configure

  func configure(collection: Collection) {
    self.titleLabel.text = collection.title

    if let totalPhotos: Int = collection.totalPhotos {
      self.descriptionLabel.text = "\(totalPhotos) photos"
    }

    if let user: User = collection.user {
      self.descriptionLabel.text?.append("•Curated by \(user.name)")
    }

    if let coverPhoto: Photo = collection.coverPhoto,
       let url: URL = .init(string: coverPhoto.urls.regular) {
      self.coverImageView.configure(url: url)
    }
  }
}
