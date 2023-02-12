//
//  LoginViewController.swift
//  Unsplash
//
//  Created by 안재영 on 2022/12/31.
//

import RxSwift
import SnapKit
import UIKit


final class LoginViewController: BaseViewController {

  // MARK: - UI Components

  private let iconImageView: BaseImageView = {
    let image: UIImage? = .init(named: "launch_icon")
    let view: BaseImageView = .init(image: image)
    view.contentMode = .scaleAspectFit
    return view
  }()

  private let titleLabel: UILabel = {
    let label: UILabel = .init()
    label.numberOfLines = 2

    let paragraphStyle: NSMutableParagraphStyle = .init()
    paragraphStyle.minimumLineHeight = 30
    paragraphStyle.alignment = .center

    let text = "The internet’s source for visuals.\nPowered by creators everywhere."
    let attributedString: NSMutableAttributedString = .init(string: text, attributes: [
      .font: UIFont.pretendard.bold(20),
      .foregroundColor: UIColor.white,
      .paragraphStyle: paragraphStyle
    ])
    label.attributedText = attributedString

    return label
  }()

  private let loginButton: UIButton = {
    var configuration: UIButton.Configuration = .filled()
    configuration.title = "Login"
    configuration.cornerStyle = .small
    configuration.imagePadding = 10
    configuration.baseBackgroundColor = .white
    configuration.activityIndicatorColorTransformer = .init({ _ -> UIColor in return .black })

    configuration.titleTextAttributesTransformer = .init({ (
      container: AttributeContainer
    ) -> AttributeContainer in
      var container: AttributeContainer = container
      container.font = .boldSystemFont(ofSize: 18)
      container.foregroundColor = .black
      return container
    })

    let button: UIButton = .init(configuration: configuration)
    return button
  }()


  // MARK: - Properties

  private let viewModel: LoginViewModel


  // MARK: - Initializers

  init(viewModel: LoginViewModel) {
    self.viewModel = viewModel

    super.init()
  }

  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }


  // MARK: - Layout

  override func addSubviews() {
    super.addSubviews()

    self.view.add(
      self.iconImageView,
      self.titleLabel,
      self.loginButton
    )
  }

  override func setConstraints() {
    super.setConstraints()

    self.iconImageView.snp.makeConstraints { (make: ConstraintMaker) in
      make.centerX.equalToSuperview()
      make.bottom.equalTo(self.titleLabel.snp.top).offset(-30)
      make.size.equalTo(70)
    }

    self.titleLabel.snp.makeConstraints { (make: ConstraintMaker) in
      make.center.equalToSuperview()
    }

    self.loginButton.snp.makeConstraints { (make: ConstraintMaker) in
      make.left.right.equalToSuperview().inset(30)
      make.bottom.equalTo(self.view.safeAreaLayoutGuide).inset(20)
      make.height.equalTo(45)
    }
  }


  // MARK: - Bind

  override func bind() {
    super.bind()

    let outputs: LoginViewModel.Outputs = self.viewModel.transform(inputs: .init(
      requestAuthorize: self.loginButton.rx
        .tap
        .throttle(.milliseconds(500), scheduler: MainScheduler.instance)
    ))

    outputs.isLoggingIn
      .drive(self.loginButton.rx.showsActivityIndicator)
      .disposed(by: self.disposeBag)

    outputs.login
      .drive(onNext: {
        WindowRouter.window?.rootViewController = TabBarController()
      })
      .disposed(by: self.disposeBag)

    outputs.presentAlert
      .drive(self.rx.presentAlert)
      .disposed(by: self.disposeBag)
  }
}
