//
//  UIProgressView+.swift
//  Unsplash
//
//  Created by ėėŽė on 2023/01/12.
//

import RxSwift
import UIKit


extension Reactive where Base: UIProgressView {

  var didComplete: Observable<Void> {
    return .create { (observer: AnyObserver<Void>) -> Disposable in
      if base.progress == 1.0 {
        observer.onNext(())
      }
      return Disposables.create()
    }
  }
}
