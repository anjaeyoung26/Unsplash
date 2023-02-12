//
//  ObservableSwitchCell.swift
//  Unsplash
//
//  Created by 안재영 on 2023/01/06.
//

import RxSwift
import UIKit


final class ObservableSwitchCell: BaseTableViewCell {

  // MARK: - UI Components

  private let `switch`: UISwitch = {
    let `switch`: UISwitch = .init()
    `switch`.isOn = true
    return `switch`
  }()


  // MARK: - Initializers

  override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
    super.init(style: style, reuseIdentifier: reuseIdentifier)

    self.accessoryView = self.`switch`
  }

  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }


  // MARK: - Bind

  func bind(observer: AnyObserver<Bool>) {
    self.switch.rx
      .isOn
      .bind(to: observer)
      .disposed(by: self.disposeBag)
  }
}
