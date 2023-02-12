//
//  UITextField+.swift
//  Unsplash
//
//  Created by 안재영 on 2022/12/30.
//

import UIKit


extension UITextField {

  func addResignButton() {
    let button: UIButton = .init(frame: .init(x: 0, y: 0, width: 40, height: 40))
    button.setImage(.init(named: "keyboard_resign_icon"), for: .normal)
    button.addTarget(self, action: #selector(self.resignFirstResponder), for: .touchUpInside)

    let toolbar: UIToolbar = .init(frame: .zero)
    toolbar.autoresizingMask = [.flexibleWidth, .flexibleHeight]
    toolbar.items = [.flexibleSpace(), .init(customView: button)]

    self.inputAccessoryView = toolbar
  }

  func setLeftInset(_ inset: CGFloat) {
    let view: UIView = .init(frame: .init(
      x: 0,
      y: 0,
      width: inset,
      height: self.frame.height
    ))
    self.leftView = view
    self.leftViewMode = .always
  }

  func setRightInset(_ inset: CGFloat) {
    let view: UIView = .init(frame: .init(
      x: 0,
      y: 0,
      width: inset,
      height: self.frame.height
    ))
    self.rightView = view
    self.rightViewMode = .always
  }
}
