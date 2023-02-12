//
//  SubmitProgressViewController.swift
//  Unsplash
//
//  Created by 안재영 on 2023/01/11.
//

import RxCocoa
import RxSwift
import SnapKit
import UIKit


final class SubmitProgressViewController: BaseViewController {

  // MARK: - UI Components

  fileprivate let progressView: UIProgressView = {
    let view: UIProgressView = .init(progressViewStyle: .bar)
    view.trackTintColor = .darkGray
    view.progressTintColor = .white
    return view
  }()

  private let titleLabel: UILabel = {
    let label: UILabel = .init()
    label.font = .boldSystemFont(ofSize: 16)
    label.text = "Submitting"
    return label
  }()

  private let cancelButton: UIButton = {
    let button: UIButton = .init()
    button.layer.cornerRadius = 3
    button.layer.masksToBounds = true
    button.layer.borderColor = UIColor.darkGray.cgColor
    button.layer.borderWidth = 0.5
    button.titleLabel?.font = .systemFont(ofSize: 16, weight: .medium)
    button.setTitle("Cancel", for: .normal)
    button.setTitleColor(.white, for: .normal)
    return button
  }()


  // MARK: - Layout

  override func addSubviews() {
    super.addSubviews()

    self.view.add(
      self.titleLabel,
      self.progressView,
      self.cancelButton
    )
  }

  override func setConstraints() {
    super.setConstraints()

    self.titleLabel.snp.makeConstraints { (make: ConstraintMaker) in
      make.centerX.equalToSuperview()
      make.top.equalToSuperview().offset(30)
    }

    self.progressView.snp.makeConstraints { (make: ConstraintMaker) in
      make.top.equalTo(self.titleLabel.snp.bottom).offset(30)
      make.left.right.equalToSuperview().inset(20)
    }

    self.cancelButton.snp.makeConstraints { (make: ConstraintMaker) in
      make.top.equalTo(self.progressView.snp.bottom).offset(30)
      make.left.right.equalToSuperview().inset(20)
      make.bottom.equalTo(self.view.safeAreaLayoutGuide).inset(15)
      make.height.equalTo(45)
    }
  }
}


// MARK: - Reactive

extension Reactive where Base: SubmitProgressViewController {

  var progress: Binder<Double> {
    return Binder(self.base) { (base: SubmitProgressViewController, progress: Double) in
      base.progressView.progress = Float(progress)
    }
  }
}
