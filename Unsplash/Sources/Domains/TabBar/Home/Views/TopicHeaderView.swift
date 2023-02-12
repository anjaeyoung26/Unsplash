//
//  TopicHeaderView.swift
//  Unsplash
//
//  Created by 안재영 on 2023/01/03.
//

import Kingfisher
import RxCocoa
import RxSwift
import SnapKit
import UIKit


final class TopicHeaderView: BaseCollectionReusableView {

  // MARK: - UI Components

  private let imageView: BaseImageView = {
    let view: BaseImageView = .init(image: nil)
    view.contentMode = .scaleAspectFit
    return view
  }()

  private let blurView: UIVisualEffectView = {
    let blurEffect: UIBlurEffect = .init(style: .dark)
    let view: UIVisualEffectView = .init(effect: blurEffect)
    return view
  }()

  private let titleLabel: UILabel = {
    let label: UILabel = .init()
    label.font = .pretendard.bold(20)
    return label
  }()

  private let subtitleLabel: UILabel = {
    let label: UILabel = .init()
    label.font = .systemFont(ofSize: 12, weight: .medium)
    label.textColor = .lightGray
    label.numberOfLines = 0
    return label
  }()

  fileprivate let submitButton: UIButton = {
    let button: UIButton = .init()
    button.backgroundColor = .white
    button.layer.cornerRadius = 5
    button.layer.masksToBounds = true
    button.titleLabel?.font = .systemFont(ofSize: 14, weight: .medium)
    button.setTitle("Submit a photo", for: .normal)
    button.setTitleColor(.black, for: .normal)
    return button
  }()


  // MARK: - Layout

  override func addSubviews() {
    super.addSubviews()

    self.add(
      self.imageView,
      self.blurView,
      self.titleLabel,
      self.subtitleLabel,
      self.submitButton
    )
  }

  override func setConstraints() {
    super.setConstraints()

    self.imageView.snp.makeConstraints { (make: ConstraintMaker) in
      make.edges.equalToSuperview()
    }

    self.blurView.snp.makeConstraints { (make: ConstraintMaker) in
      make.edges.equalToSuperview()
    }

    self.titleLabel.snp.makeConstraints { (make: ConstraintMaker) in
      make.left.equalTo(self.subtitleLabel)
      make.bottom.equalTo(self.subtitleLabel.snp.top).offset(-10)
    }

    self.subtitleLabel.snp.makeConstraints { (make: ConstraintMaker) in
      make.left.right.equalTo(self.submitButton)
      make.bottom.equalTo(self.submitButton.snp.top).offset(-25)
      make.height.equalTo(40)
    }

    self.submitButton.snp.makeConstraints { (make: ConstraintMaker) in
      make.left.right.bottom.equalToSuperview().inset(20)
      make.height.equalTo(35)
    }
  }


  // MARK: - Configure

  func configure(topic: Topic) {
    self.titleLabel.text = topic.title

    if let url: URL = .init(string: topic.coverPhoto.urls.regular) {
      self.imageView.configure(url: url)
    }
    
    let paragraphStyle: NSMutableParagraphStyle = .init()
    paragraphStyle.minimumLineHeight = 18

    let subtitleAttributedString: NSMutableAttributedString = .init(
      string: topic.description,
      attributes: [.paragraphStyle: paragraphStyle]
    )

    self.subtitleLabel.attributedText = subtitleAttributedString
  }
}


// MARK: - Reactive

extension Reactive where Base: TopicHeaderView {

  var didTapSubmitButton: ControlEvent<Void> {
    return base.submitButton.rx.tap
  }
}
