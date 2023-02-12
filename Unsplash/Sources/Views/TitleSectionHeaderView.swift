//
//  TitleSectionHeaderView.swift
//  Unsplash
//
//  Created by 안재영 on 2023/01/22.
//

import RxCocoa
import RxSwift
import SnapKit
import UIKit


final class TitleSectionHeaderView: BaseView {

  // MARK: - UI Components

  private let titleLabel: UILabel = {
    let label: UILabel = .init()
    label.font = .pretendard.bold(21)
    return label
  }()

  fileprivate let clearButton: UIButton = {
    let button: UIButton = .init()
    button.setTitle("Clear", for: .normal)
    button.titleLabel?.font = .systemFont(ofSize: 16)
    return button
  }()


  // MARK: - Properties

  var clearFont: UIFont? {
    get { return self.clearButton.titleLabel?.font }
    set { self.clearButton.titleLabel?.font = newValue }
  }

  var hideClearButton: Bool {
    get { return self.clearButton.isHidden }
    set { self.clearButton.isHidden = newValue }
  }

  var title: String? {
    get { return self.titleLabel.text }
    set { self.titleLabel.text = newValue }
  }

  var titleFont: UIFont? {
    get { return self.titleLabel.font }
    set { self.titleLabel.font = newValue }
  }


  // MARK: - Layout

  override func addSubviews() {
    super.addSubviews()

    self.add(
      self.titleLabel,
      self.clearButton
    )
  }

  override func setConstraints() {
    super.setConstraints()

    self.titleLabel.snp.makeConstraints { (make: ConstraintMaker) in
      make.centerY.left.equalToSuperview()
      make.right.equalTo(self.clearButton.snp.left)
    }

    self.clearButton.snp.makeConstraints { (make: ConstraintMaker) in
      make.centerY.right.equalToSuperview()
    }
  }
}


// MARK: - Reactive

extension Reactive where Base: TitleSectionHeaderView {

  var didTapClearButton: ControlEvent<Void> {
    return base.clearButton.rx.tap
  }
}
