//
//  UIButton+.swift
//  Unsplash
//
//  Created by 안재영 on 2023/01/17.
//

import RxCocoa
import RxSwift
import UIKit


extension Reactive where Base: UIButton {

  var showsActivityIndicator: Binder<Bool> {
    return Binder(self.base) { (base: UIButton, showsActivityIndicator: Bool) in
      base.configuration?.showsActivityIndicator = showsActivityIndicator
    }
  }
}
