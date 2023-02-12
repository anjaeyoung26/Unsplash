//
//  UserCell.swift
//  Unsplash
//
//  Created by 안재영 on 2023/01/25.
//

import SnapKit
import UIKit


final class UserCell: BaseCollectionViewCell {

  // MARK: - UI Components

  private let profileImageView: BaseImageView = {
    let view: BaseImageView = .init(image: nil)
    view.cornerType = .circle
    view.placeholder = .init(named: "user_icon")
    return view
  }()

  private let nameLabel: UILabel = {
    let label: UILabel = .init()
    label.font = .boldSystemFont(ofSize: 16)
    return label
  }()

  private let userNameLabel: UILabel = {
    let label: UILabel = .init()
    label.font = .systemFont(ofSize: 12)
    label.textColor = .lightGray
    return label
  }()

  private let separatorView: UIView = {
    let view: UIView = .init()
    view.backgroundColor = .lightGray.withAlphaComponent(0.2)
    return view
  }()


  // MARK: - Life Cycle

  override func prepareForReuse() {
    super.prepareForReuse()

    self.nameLabel.text = nil
    self.userNameLabel.text = nil
    self.profileImageView.image = nil
  }


  // MARK: - Layout

  override func addSubviews() {
    super.addSubviews()

    self.contentView.add(
      self.profileImageView,
      self.nameLabel,
      self.userNameLabel,
      self.separatorView
    )
  }

  override func setConstraints() {
    super.setConstraints()

    self.profileImageView.snp.makeConstraints { (make: ConstraintMaker) in
      make.centerY.left.equalToSuperview()
      make.size.equalTo(64)
    }

    self.nameLabel.snp.makeConstraints { (make: ConstraintMaker) in
      make.left.equalTo(self.profileImageView.snp.right).offset(20)
      make.bottom.equalTo(self.profileImageView.snp.centerY).offset(-2)
    }

    self.userNameLabel.snp.makeConstraints { (make: ConstraintMaker) in
      make.top.equalTo(self.profileImageView.snp.centerY).offset(2)
      make.left.equalTo(self.profileImageView.snp.right).offset(20)
    }

    self.separatorView.snp.makeConstraints { (make: ConstraintMaker) in
      make.left.equalTo(self.profileImageView.snp.right).offset(20)
      make.right.bottom.equalToSuperview()
      make.height.equalTo(1)
    }
  }


  // MARK: - Configure

  func configure(user: User) {
    if let urlString: String = user.profileImage?.medium,
       let url: URL = .init(string: urlString) {
      self.profileImageView.configure(url: url)
    }
    self.nameLabel.text = user.name
    self.userNameLabel.text = user.userName
  }
}
