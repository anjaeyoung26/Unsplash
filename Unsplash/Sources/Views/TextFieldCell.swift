//
//  TextFieldCell.swift
//  Unsplash
//
//  Created by 안재영 on 2023/01/05.
//

import RxCocoa
import RxSwift
import SnapKit
import UIKit


class TextFieldCell: BaseTableViewCell {

  // MARK: - UI Components

  fileprivate let textField: UITextField = {
    let textField: UITextField = .init()
    textField.clearButtonMode = .always
    return textField
  }()


  // MARK: - Properties

  var clearButtonMode: UITextField.ViewMode {
    get { return self.textField.clearButtonMode }
    set { self.textField.clearButtonMode = newValue }
  }

  var placeholder: String = "" {
    didSet { self.setPlaceholder() }
  }

  var placeholderColor: UIColor = .lightGray {
    didSet { self.setPlaceholder() }
  }

  var textLeftInset: CGFloat = 20 {
    didSet { self.updateLeftConstraint() }
  }

  var textRightInset: CGFloat = 20 {
    didSet { self.updateRightConstraint() }
  }

  var text: String? {
    get { return self.textField.text }
    set { self.textField.text = newValue }
  }

  private var textLeftConstraint: Constraint?

  private var textRightConstraint: Constraint?


  // MARK: - Layout

  override func addSubviews() {
    super.addSubviews()

    self.contentView.add(
      self.textField
    )
  }

  override func setConstraints() {
    super.setConstraints()

    self.textField.snp.makeConstraints { (make: ConstraintMaker) in
      self.textLeftConstraint = make.left.equalToSuperview().inset(self.textLeftInset).constraint
      self.textRightConstraint = make.right.equalToSuperview().inset(self.textRightInset).constraint

      make.top.bottom.equalToSuperview()
    }
  }

  private func setPlaceholder() {
    self.textField.attributedPlaceholder = .init(
      string: self.placeholder,
      attributes: [.foregroundColor: self.placeholderColor]
    )
  }

  private func updateLeftConstraint() {
    self.textLeftConstraint?.update(inset: self.textLeftInset)
  }

  private func updateRightConstraint() {
    self.textRightConstraint?.update(inset: self.textRightInset)
  }
}


// MARK: - Reactive

extension Reactive where Base: TextFieldCell {

  var didBeginEditing: ControlEvent<Void> {
    return base.textField.rx.controlEvent(.editingDidBegin)
  }

  var didEndEditing: ControlEvent<Void> {
    return base.textField.rx.controlEvent(.editingDidEnd)
  }

  var text: ControlProperty<String?> {
    return base.textField.rx.text
  }
}


// MARK: - BindableInputTextFieldCell


final class BindableInputTextFieldCell: TextFieldCell {

  // MARK: - Defines

  fileprivate struct Subject {
    let beginInput: PublishSubject<Void> = .init()
    let clearText: PublishSubject<Void> = .init()
  }


  // MARK: - Properties

  fileprivate let subject: Subject = .init()


  // MARK: - Initializers

  override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
    super.init(style: style, reuseIdentifier: reuseIdentifier)

    self.textField.delegate = self
  }

  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
}


// MARK: - UITextFieldDelegate

extension BindableInputTextFieldCell: UITextFieldDelegate {

  func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
    self.subject.beginInput.onNext(())
    return false
  }

  func textFieldShouldClear(_ textField: UITextField) -> Bool {
    self.subject.clearText.onNext(())
    textField.text = nil
    textField.resignFirstResponder()
    return false
  }
}


// MARK: - Reactive

extension Reactive where Base: BindableInputTextFieldCell {

  var didBeginInput: Observable<Void> {
    return base.subject
      .beginInput
      .asObservable()
  }

  var didClearText: Observable<Void> {
    return base.subject
      .clearText
      .asObservable()
  }
}
