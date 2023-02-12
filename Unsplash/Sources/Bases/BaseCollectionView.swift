//
//  BaseCollectionView.swift
//  Unsplash
//
//  Created by 안재영 on 2023/01/14.
//

import UIKit


class BaseCollectionView: UICollectionView {

  // MARK: - Properties

  override var intrinsicContentSize: CGSize {
    return (self.isFittingContent) ? self.contentSize : super.intrinsicContentSize
  }

  override var contentSize: CGSize {
    didSet {
      if self.isFittingContent {
        self.invalidateIntrinsicContentSize()
      }
    }
  }

  var isFittingContent: Bool = false

  var endEditingWhenTouchesBegan: Bool = false


  // MARK: - Initializers

  override init(frame: CGRect, collectionViewLayout layout: UICollectionViewLayout) {
    super.init(frame: frame, collectionViewLayout: layout)

    self.backgroundColor = .clear
    self.showsVerticalScrollIndicator = false
    self.showsHorizontalScrollIndicator = false
  }

  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }


  // MARK: - Life Cycle

  override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
    super.touchesBegan(touches, with: event)

    if self.endEditingWhenTouchesBegan {
      self.endEditing(true)
    }
  }
}
