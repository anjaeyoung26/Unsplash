//
//  UIScrollView+.swift
//  Unsplash
//
//  Created by 안재영 on 2023/01/26.
//

import RxSwift
import UIKit


extension Reactive where Base: UIScrollView {

  func isReachedBottom(threshold: CGFloat) -> Observable<Bool> {
    return base.rx
      .didScroll
      .map { _ -> Bool in
        return base.contentOffset.y >= (base.contentSize.height - base.frame.size.height - threshold)
      }
      .distinctUntilChanged()
  }
}
