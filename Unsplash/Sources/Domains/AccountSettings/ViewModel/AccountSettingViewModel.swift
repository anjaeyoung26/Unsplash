//
//  AccountSettingViewModel.swift
//  Unsplash
//
//  Created by 안재영 on 2023/01/31.
//

import Foundation
import RxCocoa
import RxSwift


final class AccountSettingViewModel: ViewModelType {

  // MARK: - Defines

  struct Inputs {
    let requestSections: Observable<Void>
  }

  struct Outputs {
    let presentAlert: Driver<RxAlert<Void>>
    let sections: Driver<[AccountSettingSection]>
  }

  private struct Subject {
    let error: PublishSubject<Error> = .init()
  }


  // MARK: - Properties

  private let disposeBag: DisposeBag = .init()

  private let subject: Subject = .init()

  private let userService: UserServiceType


  // MARK: - Initializers

  init(userService: UserServiceType) {
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

    let sections: Observable<[AccountSettingSection]> = inputs.requestSections
      .map { _ -> [AccountSettingSection] in
        return [
          .init(items: [.changeProfilePhoto]),
          .init(items: [.editProfile, .changePassword, .account])
        ]
      }

    return .init(
      presentAlert: presentAlert.asDriver(onErrorDriveWith: .empty()),
      sections: sections.asDriver(onErrorDriveWith: .empty())
    )
  }
}
