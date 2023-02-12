//
//  UICollectionView+.swift
//  Unsplash
//
//  Created by 안재영 on 2022/12/28.
//

import RxCocoa
import RxSwift
import UIKit


extension UICollectionView {

  func register<Cell: ReusableType>(_ cell: Cell.Type) {
    self.register(cell.classType, forCellWithReuseIdentifier: cell.identifier)
  }

  func register<View: ReusableType>(_ type: View.Type, kind: String) {
    self.register(
      type.classType,
      forSupplementaryViewOfKind: kind,
      withReuseIdentifier: type.identifier
    )
  }

  func dequeue<Cell: UICollectionViewCell & ReusableType>(
    _ cell: Cell.Type,
    for indexPath: IndexPath
  ) -> Cell {
    return self.dequeueReusableCell(
      withReuseIdentifier: cell.identifier,
      for: indexPath
    ) as? Cell ?? .init()
  }

  func dequeue<View: UICollectionReusableView & ReusableType>(
    _ view: View.Type,
    kind: String,
    for indexPath: IndexPath
  ) -> View {
    guard let view = self.dequeueReusableSupplementaryView(
      ofKind: kind,
      withReuseIdentifier: view.identifier,
      for: indexPath
    ) as? View else {
      return .init()
    }
    return view
  }
}


// MARK: - Background

extension UICollectionView {

  func setBackgroundView(
    image: UIImage?,
    text: String,
    textColor: UIColor = .label,
    font: UIFont? = .systemFont(ofSize: 15)
  ) {
    let imageView: UIImageView = .init()
    imageView.image = image
    imageView.contentMode = .scaleAspectFit
    imageView.translatesAutoresizingMaskIntoConstraints = false

    let label: UILabel = .init()
    label.font = font
    label.text = text
    label.textColor = textColor
    label.textAlignment = .center
    label.translatesAutoresizingMaskIntoConstraints = false

    let backgroundView: UIView = .init()
    backgroundView.addSubview(imageView)
    backgroundView.addSubview(label)
    self.backgroundView = backgroundView

    let imageSizeConstant: CGFloat = (image != nil) ? (image!.size.width) : 0
    let labelBottomConstant: CGFloat = (image != nil) ? 15 : 0

    NSLayoutConstraint.activate([
      imageView.widthAnchor.constraint(equalToConstant: imageSizeConstant),
      imageView.heightAnchor.constraint(equalToConstant: imageSizeConstant),
      imageView.centerXAnchor.constraint(equalTo: self.centerXAnchor),
      imageView.centerYAnchor.constraint(equalTo: self.centerYAnchor, constant: -60),
      label.centerXAnchor.constraint(equalTo: self.centerXAnchor),
      label.topAnchor.constraint(equalTo: imageView.bottomAnchor, constant: labelBottomConstant)
    ])
  }
}
