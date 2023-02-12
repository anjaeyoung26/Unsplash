//
//  UITextView+.swift
//  Unsplash
//
//  Created by 안재영 on 2023/01/06.
//

import UIKit


extension UITextView {

  func addResignButton() {
    let button: UIButton = .init(frame: .init(x: 0, y: 0, width: 40, height: 40))
    button.setImage(.init(named: "keyboard_resign_icon"), for: .normal)
    button.addTarget(self, action: #selector(self.resignFirstResponder), for: .touchUpInside)

    let toolbar: UIToolbar = .init(frame: .zero)
    toolbar.autoresizingMask = [.flexibleWidth, .flexibleHeight]
    toolbar.items = [.flexibleSpace(), .init(customView: button)]

    self.inputAccessoryView = toolbar
  }
}
