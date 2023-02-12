//
//  LoginViewModel.swift
//  Unsplash
//
//  Created by 안재영 on 2022/12/31.
//

import Foundation
import RxCocoa
import RxSwift


final class LoginViewModel: ViewModelType {

  // MARK: - Defines

  struct Inputs {
    let requestAuthorize: Observable<Void>
  }

  struct Outputs {
    let isLoggingIn: RxActivityIndicator
    let login: Driver<Void>
    let presentAlert: Driver<RxAlert<Void>>
  }

  private struct Subject {
    let error: PublishSubject<Error> = .init()
  }


  // MARK: - Properties

  private let disposeBag: DisposeBag = .init()

  private let subject: Subject = .init()

  private let authService: OAuthServiceType

  private let keychainService: KeychainServiceType

  private let userService: UserServiceType


  // MARK: - Initializers

  init(
    authService: OAuthServiceType,
    keychainService: KeychainServiceType,
    userService: UserServiceType
  ) {
    self.authService = authService
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

    let isLoggingIn: RxActivityIndicator = .init()

    let scope: String = [
      "public",
      "read_user",
      "write_user",
      "read_photos",
      "write_photos",
      "write_likes",
      "read_collections",
      "write_collections"
    ].joined(separator: "+")

    let code: Observable<String> = inputs.requestAuthorize
      .flatMapLatest { [weak self] _ -> Observable<String> in
        return self?.authService
          .authorize(parameter: .init(
            clientID: "70JVSFgj47Z68ZHj45z8g8geVTLXEKJpcsY78c5mY6w",
            redirectURI: "unsplash://oauth/callback",
            responseType: "code",
            scope: scope
          ))
          .asObservable()
          .trackActivity(isLoggingIn)
          .suppressError(observer: errorObserver) ?? .empty()
      }

    let token: Observable<Token> = code
      .flatMapLatest { [weak self] (code: String) -> Observable<Token> in
        return self?.authService
          .token(parameter: .init(
            clientID: "70JVSFgj47Z68ZHj45z8g8geVTLXEKJpcsY78c5mY6w",
            clientSecret: "DL-ZByW9gnfeaU30bxXJ-hd9rW30tvO0tsnyYELyTuQ",
            code: code,
            grantType: "authorization_code",
            redirectURI: "unsplash://oauth/callback"
          ))
          .asObservable()
          .trackActivity(isLoggingIn)
          .suppressError(observer: errorObserver) ?? .empty()
      }
      .do(onNext: { [weak self] (token: Token) in try self?.keychainService.saveToken(token) })

    let login: Observable<Void> = token
      .flatMapLatest { [weak self] _ -> Observable<User> in
        return self?.userService
          .me()
          .asObservable()
          .trackActivity(isLoggingIn)
          .suppressError(observer: errorObserver) ?? .empty()
      }
      .do(onNext: { (user: User) in User.update(user) })
      .map { _ in }

    return .init(
      isLoggingIn: isLoggingIn,
      login: login.asDriver(onErrorDriveWith: .empty()),
      presentAlert: presentAlert.asDriver(onErrorDriveWith: .empty())
    )
  }
}
