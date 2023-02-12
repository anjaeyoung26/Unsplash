//
//  TextViewCell.swift
//  Unsplash
//
//  Created by 안재영 on 2023/01/09.
//

import RxCocoa
import RxSwift
import SnapKit
import UIKit


final class TextViewCell: BaseTableViewCell {

  // MARK: - UI Components

  fileprivate let textView: UITextView = {
    let view: UITextView = .init()
    view.font = .systemFont(ofSize: 17)
    view.textColor = .white
    view.textContainerInset = .init(top: 13, left: 15, bottom: 13, right: 15)
    return view
  }()


  // MARK: - Properties

  override var backgroundColor: UIColor? {
    didSet { self.textView.backgroundColor = backgroundColor }
  }

  var font: UIFont? {
    get { return self.textView.font }
    set { self.textView.font = newValue }
  }

  var text: String? {
    get { return self.textView.text }
    set { return self.textView.text = newValue }
  }

  var textColor: UIColor? {
    get { return self.textView.textColor }
    set { self.textView.textColor = newValue }
  }

  var textInset: UIEdgeInsets {
    get { return self.textView.textContainerInset }
    set { self.textView.textContainerInset = newValue }
  }

  var placeholder: String = "" {
    didSet { self.setPlaceholderIfNeeded() }
  }

  var placeholderColor: UIColor = .lightGray {
    didSet { self.setPlaceholderIfNeeded() }
  }

  var maxTextLength: Int = 100


  // MARK: - Initializers

  override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
    super.init(style: style, reuseIdentifier: reuseIdentifier)

    self.textView.delegate = self
  }

  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }


  // MARK: - Layout

  override func addSubviews() {
    super.addSubviews()

    self.contentView.add(
      self.textView
    )
  }

  override func setConstraints() {
    super.setConstraints()

    self.textView.snp.makeConstraints { (make: ConstraintMaker) in
      make.edges.equalToSuperview()
    }
  }

  fileprivate func setPlaceholderIfNeeded() {
    if self.textView.text.isEmpty {
      self.textView.text = self.placeholder
      self.textView.textColor = self.placeholderColor
    }
  }

  fileprivate func removePlaceholderIfNeeded() {
    if self.textView.textColor == self.placeholderColor {
      self.textView.textColor = .black
      self.textView.text = nil
    }
  }
}


// MARK: - UITextViewDelegate

extension TextViewCell: UITextViewDelegate {

  func textView(
    _ textView: UITextView,
    shouldChangeTextIn range: NSRange,
    replacementText text: String
  ) -> Bool {
    guard let currentText: String = textView.text else { return true }
    let length: Int = currentText.count + text.count - range.length
    return length <= self.maxTextLength
  }

  func textViewDidBeginEditing(_ textView: UITextView) {
    self.removePlaceholderIfNeeded()
  }

  func textViewDidEndEditing(_ textView: UITextView) {
    self.setPlaceholderIfNeeded()
  }
}


// MARK: - Reactive

extension Reactive where Base: TextViewCell {

  var text: ControlProperty<String> {
    return base.textView.rx
      .text
      .orEmpty
  }
}
