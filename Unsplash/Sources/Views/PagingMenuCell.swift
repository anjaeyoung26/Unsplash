//
//  PagingMenuCell.swift
//  Unsplash
//
//  Created by 안재영 on 2023/01/02.
//

import PagingKit
import SnapKit
import UIKit


final class PagingMenuCell: PagingMenuViewCell {

  // MARK: - UI Components

  private let titleLabel: UILabel = {
    let label: UILabel = .init()
    label.font = .systemFont(ofSize: 14, weight: .medium)
    label.textAlignment = .center
    return label
  }()


  // MARK: - Properties

  var title: String? {
    get { return self.titleLabel.text }
    set { self.titleLabel.text = newValue }
  }


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
    self.addSubview(
      self.titleLabel
    )
  }

  func setConstraints() {
    self.titleLabel.snp.makeConstraints { (make: ConstraintMaker) in
      make.edges.equalToSuperview()
    }
  }
}
