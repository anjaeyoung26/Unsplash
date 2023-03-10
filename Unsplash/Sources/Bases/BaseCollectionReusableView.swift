//
//  BaseCollectionReusableView.swift
//  Unsplash
//
//  Created by ėėŽė on 2023/01/07.
//

import RxSwift
import UIKit


class BaseCollectionReusableView: UICollectionReusableView, ReusableType {

  // MARK: - Properties

  var disposeBag: DisposeBag = .init()


  // MARK: - Initializers

  override init(frame: CGRect) {
    super.init(frame: frame)

    self.addSubviews()
    self.setConstraints()
  }

  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }


  // MARK: - Layout

  func addSubviews() {

  }

  func setConstraints() {

  }
}
