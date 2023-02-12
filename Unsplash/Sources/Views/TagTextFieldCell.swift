//
//  TagTextFieldCell.swift
//  Unsplash
//
//  Created by 안재영 on 2023/01/09.
//

import RxCocoa
import RxSwift
import SnapKit
import UIKit
import WSTagsField


final class TagTextFieldCell: BaseTableViewCell {

  // MARK: - Defines

  fileprivate struct Subject {
    let height: PublishSubject<CGFloat> = .init()
    let tags: PublishSubject<[String]> = .init()
  }


  // MARK: - UI Components

  fileprivate let tagsField: WSTagsField = {
    let tagsField: WSTagsField = .init()
    tagsField.font = .systemFont(ofSize: 15)
    tagsField.textColor = .white
    tagsField.tintColor = .darkGray
    tagsField.selectedTextColor = .white
    tagsField.textField.font = .systemFont(ofSize: 17)
    tagsField.textField.tintColor = .white
    tagsField.cornerRadius = 5
    tagsField.spaceBetweenTags = 8
    tagsField.spaceBetweenLines = 18
    tagsField.placeholderFont = .systemFont(ofSize: 18)
    tagsField.placeholderColor = .lightGray
    tagsField.placeholderAlwaysVisible = true
    tagsField.contentInset = .init(top: 13, left: 20, bottom: 13, right: 20)
    tagsField.layoutMargins = .init(top: 8, left: 8, bottom: 8, right: 8)
    return tagsField
  }()


  // MARK: - Properties

  override var backgroundColor: UIColor? {
    didSet { self.tagsField.backgroundColor = backgroundColor }
  }

  var font: UIFont? {
    get { return self.tagsField.font }
    set { self.tagsField.font = newValue }
  }

  var placeholder: String {
    get { return self.tagsField.placeholder }
    set { self.tagsField.placeholder = newValue }
  }

  var placeholderAlwaysVisible: Bool {
    get { return self.tagsField.placeholderAlwaysVisible }
    set { self.tagsField.placeholderAlwaysVisible = newValue }
  }

  var placeholderColor: UIColor? {
    get { return self.tagsField.placeholderColor }
    set { self.tagsField.placeholderColor = newValue }
  }

  var placeholderFont: UIFont? {
    get { return self.tagsField.placeholderFont }
    set { self.tagsField.placeholderFont = newValue }
  }

  var spaceBetweenTags: CGFloat {
    get { return self.tagsField.spaceBetweenTags }
    set { self.tagsField.spaceBetweenTags = newValue }
  }

  var spaceBetweenLines: CGFloat {
    get { return self.tagsField.spaceBetweenLines }
    set { self.tagsField.spaceBetweenLines = newValue }
  }

  var selectedTagTextColor: UIColor? {
    get { return self.tagsField.selectedTextColor }
    set { self.tagsField.selectedTextColor = newValue }
  }

  var tagBackgroundColor: UIColor? {
    get { return self.tagsField.tintColor }
    set { self.tagsField.tintColor = newValue }
  }

  var tagContentInset: UIEdgeInsets {
    get { return self.tagsField.contentInset }
    set { self.tagsField.contentInset = newValue }
  }

  var tagCornerRadius: CGFloat {
    get { return self.tagsField.cornerRadius }
    set { self.tagsField.cornerRadius = newValue }
  }

  var tagFont: UIFont? {
    get { return self.tagsField.font }
    set { self.tagsField.font = newValue }
  }

  var tagLayoutMargins: UIEdgeInsets {
    get { return self.tagsField.layoutMargins }
    set { self.tagsField.layoutMargins = newValue }
  }

  var textColor: UIColor? {
    get { return self.tagsField.textColor }
    set { self.tagsField.textColor = newValue }
  }

  fileprivate let subject: Subject = .init()

  private var initHeight: CGFloat = 0


  // MARK: - Layout

  override func addSubviews() {
    super.addSubviews()

    self.contentView.add(
      self.tagsField
    )
  }

  override func setConstraints() {
    super.setConstraints()

    self.tagsField.snp.makeConstraints { (make: ConstraintMaker) in
      make.edges.equalToSuperview()
    }
  }


  // MARK: - Bind

  override func bind() {
    super.bind()

    self.tagsField.onDidAddTag = { [weak self] (_, _) in self?.updateTags() }
    self.tagsField.onDidRemoveTag = { [weak self] (_, _) in self?.updateTags() }
    self.tagsField.onDidChangeHeightTo = { [weak self] (tagsField: WSTagsField, height: CGFloat) in
      guard let self = self else { return }

      if self.initHeight == 0 {
        self.initHeight = height
      }

      if height > self.initHeight {
        self.subject.height.onNext(height - tagsField.spaceBetweenTags)
      } else {
        self.subject.height.onNext(height)
      }
    }
  }

  private func updateTags() {
    let tags: [String] = self.tagsField.tags.map { (tag: WSTag) -> String in return tag.text }
    self.subject.tags.onNext(tags)
  }
}


// MARK: - Reactive

extension Reactive where Base: TagTextFieldCell {

  var didChangeTags: Observable<[String]> {
    return base.subject
      .tags
      .asObservable()
  }

  var didChangeHeight: Observable<CGFloat> {
    return base.subject
      .height
      .asObservable()
  }
}
