//
//  AddToCollectionCell.swift
//  Unsplash
//
//  Created by 안재영 on 2023/02/07.
//

import Kingfisher
import RxCocoa
import RxSwift
import SnapKit
import UIKit


final class AddToCollectionCell: BaseTableViewCell {

  // MARK: - UI Components

  private let coverImageView: BaseImageView = {
    let view: BaseImageView = .init(image: nil)
    view.cornerType = .radius(7)
    view.options = [
      .transition(.fade(0.5)),
      .keepCurrentImageWhileLoading
    ]
    return view
  }()

  private let lockImageView: BaseImageView = {
    let image: UIImage? = .init(systemName: "lock.fill")
    let view: BaseImageView = .init(image: image)
    view.tintColor = .white
    return view
  }()

  private let titleLabel: UILabel = {
    let label: UILabel = .init()
    label.font = .boldSystemFont(ofSize: 15)
    return label
  }()

  private let totalPhotosLabel: UILabel = {
    let label: UILabel = .init()
    label.font = .systemFont(ofSize: 13)
    label.textColor = .lightGray
    return label
  }()

  private let addButton: UIButton = {
    var configuration: UIButton.Configuration = .plain()
    configuration.contentInsets.trailing = 0
    configuration.baseBackgroundColor = .clear

    let button: UIButton = .init(configuration: configuration)
    button.configurationUpdateHandler = { (button: UIButton) in
      switch button.state {
      case .selected:
        button.configuration?.image = .init(named: "check_icon")
      default:
        button.configuration?.image = .init(named: "plus_icon")
      }
    }

    return button
  }()


  // MARK: - Life Cycle

  override func prepareForReuse() {
    super.prepareForReuse()

    self.coverImageView.image = nil
    self.titleLabel.text = nil
    self.totalPhotosLabel.text = nil
  }

  override func setSelected(_ selected: Bool, animated: Bool) {
    super.setSelected(selected, animated: animated)

    self.addButton.isSelected = selected
  }


  // MARK: - Layout

  override func addSubviews() {
    super.addSubviews()

    self.contentView.add(
      self.coverImageView,
      self.lockImageView,
      self.titleLabel,
      self.totalPhotosLabel,
      self.addButton
    )
  }

  override func setConstraints() {
    super.setConstraints()

    self.coverImageView.snp.makeConstraints { (make: ConstraintMaker) in
      make.top.bottom.equalToSuperview().inset(10)
      make.left.equalToSuperview()
      make.size.equalTo(55)
    }

    self.lockImageView.snp.makeConstraints { (make: ConstraintMaker) in
      make.center.equalTo(self.coverImageView)
      make.size.equalTo(25)
    }

    self.titleLabel.snp.makeConstraints { (make: ConstraintMaker) in
      make.left.equalTo(self.coverImageView.snp.right).offset(15)
      make.bottom.equalTo(self.coverImageView.snp.centerY).offset(-2)
    }

    self.totalPhotosLabel.snp.makeConstraints { (make: ConstraintMaker) in
      make.top.equalTo(self.coverImageView.snp.centerY).offset(2)
      make.left.equalTo(self.coverImageView.snp.right).offset(15)
    }

    self.addButton.snp.makeConstraints { (make: ConstraintMaker) in
      make.centerY.right.equalToSuperview()
    }
  }


  // MARK: - Configure

  func configure(collection: Collection) {
    self.titleLabel.text = collection.title
    self.lockImageView.isHidden = !(collection.isPrivate ?? false)

    if let totalPhotos: Int = collection.totalPhotos {
      self.totalPhotosLabel.text = "\(totalPhotos) photos"
    }

    if let urlString: String = collection.coverPhoto?.urls.thumb,
       let url: URL = .init(string: urlString) {
      self.coverImageView.configure(url: url)
    }
  }
}
