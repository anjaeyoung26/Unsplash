//
//  SplashViewController.swift
//  Unsplash
//
//  Created by 안재영 on 2023/02/05.
//

import RxCocoa
import RxSwift
import SnapKit
import UIKit


final class SplashViewController: BaseViewController {

  // MARK: - UI Components

  private let imageView: BaseImageView = {
    let image: UIImage? = .init(named: "launch_icon")
    let view: BaseImageView = .init(image: image)
    return view
  }()


  // MARK: - Properties

  private let viewModel: SplashViewModel


  // MARK: - Initializers

  init(viewModel: SplashViewModel) {
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
      self.imageView
    )
  }

  override func setConstraints() {
    super.setConstraints()

    self.imageView.snp.makeConstraints { (make: ConstraintMaker) in
      make.center.equalToSuperview()
      make.size.equalTo(70)
    }
  }


  // MARK: - Bind

  override func bind() {
    super.bind()

    let outputs: SplashViewModel.Outputs = self.viewModel.transform(inputs: .init(
      requestValidateLogin: self.rx
        .viewDidLoad
        .asObservable()
    ))

    outputs.notLoggedIn
      .drive(onNext: {
        let loginViewController: LoginViewController = AppAssembler.resolve(LoginViewController.self)
        
        WindowRouter.window?.rootViewController = loginViewController
      })
      .disposed(by: self.disposeBag)

    outputs.loggedIn
      .drive(onNext: { _ in
        let tabBarController: TabBarController = .init()
        
        WindowRouter.window?.rootViewController = tabBarController
      })
      .disposed(by: self.disposeBag)

    outputs.presentAlert
      .drive(self.rx.presentAlert)
      .disposed(by: self.disposeBag)
  }
}
