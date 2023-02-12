//
//  AppSummaryCell.swift
//  Unsplash
//
//  Created by 안재영 on 2023/01/01.
//

import SnapKit
import UIKit


final class AppSummaryCell: BaseTableViewCell {

  // MARK: - UI Components

  private let iconImageView: BaseImageView = {
    let view: BaseImageView = .init(image: nil)
    return view
  }()

  private let nameLabel: UILabel = {
    let label: UILabel = .init()
    label.font = .pretendard.bold(20)
    return label
  }()

  private let versionLabel: UILabel = {
    let label: UILabel = .init()
    label.font = .systemFont(ofSize: 12)
    label.textColor = .gray
    return label
  }()


  // MARK: - Initializers

  override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
    super.init(style: style, reuseIdentifier: reuseIdentifier)

    self.contentView.backgroundColor = .init(red: 44/255, green: 44/255, blue: 47/255, alpha: 1.0)
  }

  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }


  // MARK: - Lify Cycle

  override func prepareForReuse() {
    super.prepareForReuse()

    self.iconImageView.image = nil
    self.nameLabel.text = nil
    self.versionLabel.text = nil
  }


  // MARK: - Layout

  override func addSubviews() {
    super.addSubviews()

    self.contentView.add(
      self.iconImageView,
      self.nameLabel,
      self.versionLabel
    )
  }

  override func setConstraints() {
    super.setConstraints()

    self.iconImageView.snp.makeConstraints { (make: ConstraintMaker) in
      make.centerX.equalToSuperview()
      make.top.equalToSuperview().offset(27)
      make.size.equalTo(25)
    }

    self.nameLabel.snp.makeConstraints { (make: ConstraintMaker) in
      make.centerX.equalToSuperview()
      make.top.equalTo(self.iconImageView.snp.bottom).offset(4)
    }

    self.versionLabel.snp.makeConstraints { (make: ConstraintMaker) in
      make.centerX.equalToSuperview()
      make.top.equalTo(self.nameLabel.snp.bottom).offset(7)
      make.bottom.equalToSuperview().inset(25)
    }
  }


  // MARK: - Configure

  func configure(summary: AppSummary) {
    self.iconImageView.image = summary.icon
    self.nameLabel.text = summary.name
    self.versionLabel.text = "v" + summary.version
  }
}


