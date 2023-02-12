//
//  BaseCollectionViewCell.swift
//  Unsplash
//
//  Created by 안재영 on 2022/12/28.
//

import RxSwift
import UIKit


class BaseCollectionViewCell: UICollectionViewCell, ReusableType {

  // MARK: - Properties

  var disposeBag: DisposeBag = .init()


  // MARK: - Initializers

  override init(frame: CGRect) {
    super.init(frame: frame)
    
    self.bind()
    self.addSubviews()
    self.setConstraints()
  }

  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented.")
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
