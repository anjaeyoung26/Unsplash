//
//  BaseTableViewCell.swift
//  Unsplash
//
//  Created by 안재영 on 2023/01/01.
//

import RxSwift
import UIKit


class BaseTableViewCell: UITableViewCell, ReusableType {

  // MARK: - Properties

  var disposeBag: DisposeBag = .init()


  // MARK: - Initializers

  override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
    super.init(style: style, reuseIdentifier: reuseIdentifier)

    self.bind()
    self.addSubviews()
    self.setConstraints()
    self.selectionStyle = .none
  }

  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }


  // MARK: - Layout

  func addSubviews() {

  }

  func setConstraints() {

  }


  // MARK: - Bind

  func bind() {

  }
}
