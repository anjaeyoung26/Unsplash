//
//  SwitchCell.swift
//  Unsplash
//
//  Created by 안재영 on 2023/02/08.
//

import RxCocoa
import RxSwift
import SnapKit
import UIKit


final class SwitchCell: BaseTableViewCell {

  // MARK: - Properties

  private let titleLabel: UILabel = {
    let label: UILabel = .init()
    label.font = .systemFont(ofSize: 15)
    return label
  }()

  private let subtitleLabel: UILabel = {
    let label: UILabel = .init()
    label.font = .systemFont(ofSize: 11)
    label.textColor = .gray
    return label
  }()

  fileprivate let `switch`: UISwitch = {
    let `switch`: UISwitch = .init()
    return `switch`
  }()


  // MARK: - Properties

  var title: String? {
    get { return self.titleLabel.text }
    set { self.titleLabel.text = newValue }
  }

  var titleColor: UIColor? {
    get { return self.titleLabel.textColor }
    set { self.titleLabel.textColor = newValue }
  }

  var titleFont: UIFont? {
    get { return self.titleLabel.font }
    set { self.titleLabel.font = newValue }
  }

  var subtitle: String? {
    get { return self.subtitleLabel.text }
    set { self.subtitleLabel.text = newValue }
  }

  var subtitleColor: UIColor? {
    get { return self.subtitleLabel.textColor }
    set { self.subtitleLabel.textColor = newValue }
  }

  var subtitleFont: UIFont? {
    get { return self.subtitleLabel.font }
    set { self.subtitleLabel.font = newValue }
  }

  var isSwitchOn: Bool {
    get { return self.switch.isOn }
    set { self.switch.isOn = newValue }
  }


  // MARK: - Layout

  override func addSubviews() {
    super.addSubviews()

    self.contentView.add(
      self.titleLabel,
      self.subtitleLabel,
      self.switch
    )
  }

  override func setConstraints() {
    super.setConstraints()

    self.titleLabel.snp.makeConstraints { (make: ConstraintMaker) in
      make.top.left.equalToSuperview().inset(20)
      make.bottom.equalTo(self.contentView.snp.centerY)
    }

    self.subtitleLabel.snp.makeConstraints { (make: ConstraintMaker) in
      make.left.bottom.equalToSuperview().inset(20)
      make.top.equalTo(self.titleLabel.snp.bottom).offset(3)
    }

    self.switch.snp.makeConstraints { (make: ConstraintMaker) in
      make.centerY.equalToSuperview()
      make.right.equalToSuperview().inset(20)
    }
  }
}


// MARK: - Reactive

extension Reactive where Base: SwitchCell {

  var isSwitchOn: ControlProperty<Bool> {
    return base.switch.rx.isOn
  }
}
