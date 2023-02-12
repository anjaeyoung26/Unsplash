//
//  BaseView.swift
//  Unsplash
//
//  Created by 안재영 on 2023/01/05.
//

import RxSwift
import UIKit


class BaseView: UIView {

  // MARK: - Properties

  var disposeBag: DisposeBag = .init()


  // MARK: - Initializers

  override init(frame: CGRect) {
    super.init(frame: frame)

    self.bind()
    self.addSubviews()
    self.setConstraints()
    self.setComponents()
  }

  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }


  // MARK: - Layout

  func addSubviews() {

  }

  func setConstraints() {

  }

  func setComponents() {

  }


  // MARK: - Bind

  func bind() {

  }
}
