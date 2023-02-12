//
//  SplashViewModel.swift
//  Unsplash
//
//  Created by 안재영 on 2023/02/05.
//

import Foundation
import RxCocoa
import RxSwift


final class SplashViewModel: ViewModelType {

  // MARK: - Defines

  struct Inputs {
    let requestValidateLogin: Observable<Void>
  }

  struct Outputs {
    let loggedIn: Driver<User>
    let notLoggedIn: Driver<Void>
    let presentAlert: Driver<RxAlert<Void>>
  }

  private struct Subject {
    let error: PublishSubject<Error> = .init()
  }


  // MARK: - Properties

  private let disposeBag: DisposeBag = .init()

  private let subject: Subject = .init()

  private let keychainService: KeychainServiceType

  private let userService: UserServiceType


  // MARK: - Initializers

  init(keychainService: KeychainServiceType, userService: UserServiceType) {
    self.keychainService = keychainService
    self.userService = userService
  }


  // MARK: - Transform

  func transform(inputs: Inputs) -> Outputs {
    let errorObserver: PublishSubject<Error> = self.subject.error.asObserver()

    let presentAlert: Observable<RxAlert<Void>> = errorObserver
      .flatMapLatest { (error: Error) -> Observable<RxAlert<Void>> in
        return .just(.init(
          actions: [.init(style: .cancel, title: "OK", value: ())],
          message: error.localizedDescription,
          title: nil
        ))
      }

    let token: Observable<Token?> = inputs.requestValidateLogin
      .map { [weak self] _ -> Token? in return self?.keychainService.fetchToken() }
      .share(replay: 1)

    let notLoggedIn: Observable<Void> = token
      .filter { (token: Token?) -> Bool in return token == nil }
      .map { _ in }

    let loggedIn: Observable<User> = token
      .filter { (token: Token?) -> Bool in return token != nil }
      .flatMapLatest { [weak self] _ -> Observable<User> in
        return self?.userService
          .me()
          .asObservable()
          .suppressError(observer: errorObserver) ?? .empty()
      }
      .do(onNext: { (user: User) in User.update(user) })

    return .init(
      loggedIn: loggedIn.asDriver(onErrorDriveWith: .empty()),
      notLoggedIn: notLoggedIn.asDriver(onErrorDriveWith: .empty()),
      presentAlert: presentAlert.asDriver(onErrorDriveWith: .empty())
    )
  }
}
