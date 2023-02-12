//
//  ChangeProfilePhotoCell.swift
//  Unsplash
//
//  Created by 안재영 on 2023/02/06.
//

import SnapKit
import UIKit


final class ChangeProfilePhotoCell: BaseTableViewCell {

  // MARK: - UI Components

  private let profileImageView: BaseImageView = {
    let view: BaseImageView = .init(image: nil)
    view.cornerType = .circle
    view.placeholder = .init(named: "user_icon")
    return view
  }()

  private let label: UILabel = {
    let label: UILabel = .init()
    label.font = .systemFont(ofSize: 12)
    label.text = "Change Profile Photo"
    label.textColor = .white.withAlphaComponent(0.8)
    label.textAlignment = .center
    return label
  }()


  // MARK: - Properties

  var cornerRadius: CGFloat = 5


  // MARK: - Life Cycle

  override func layoutSubviews() {
    super.layoutSubviews()

    self.contentView.layer.cornerRadius = self.cornerRadius
    self.contentView.layer.masksToBounds = true
  }

  override func prepareForReuse() {
    super.prepareForReuse()

    self.label.text = nil
    self.profileImageView.image = nil
  }


  // MARK: - Layout

  override func addSubviews() {
    super.addSubviews()

    self.contentView.add(
      self.profileImageView,
      self.label
    )
  }

  override func setConstraints() {
    super.setConstraints()

    self.profileImageView.snp.makeConstraints { (make: ConstraintMaker) in
      make.centerX.equalToSuperview()
      make.top.equalToSuperview().offset(15)
      make.size.equalTo(95)
    }

    self.label.snp.makeConstraints { (make: ConstraintMaker) in
      make.centerX.equalToSuperview()
      make.top.equalTo(self.profileImageView.snp.bottom).offset(15)
      make.bottom.equalToSuperview().inset(15)
    }
  }


  // MARK: - Configure

  func configure(url: URL) {
    self.profileImageView.configure(url: url)
  }
}
