//
//  EditProfileViewModel.swift
//  Unsplash
//
//  Created by 안재영 on 2023/02/06.
//

import Foundation
import RxCocoa
import RxSwift


final class EditProfileViewModel: ViewModelType {

  // MARK: - Defines

  struct Inputs {
    let requestSections: Observable<User>
    let updateProfile: Observable<Parameter.UpdateProfile>
  }

  struct Outputs {
    let presentAlert: Driver<RxAlert<Void>>
    let isUpdatingProfile: RxActivityIndicator
    let sections: Driver<[EditProfileSection]>
    let updateProfile: Driver<User>
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

    let sections: Observable<[EditProfileSection]> = inputs.requestSections
      .map { (user: User) -> [EditProfileSection] in
        return [
          .init(
            items: [
              .firstName(user.firstName),
              .lastName(user.lastName),
              .userName(user.userName),
              .email(user.email)
            ],
            title: "PROFILE"
          ),
          .init(
            items: [
              .location(user.location),
              .website(user.portfolioURL)
            ],
            title: "ABOUT"
          )
        ]
      }

    let isUpdatingProfile: RxActivityIndicator = .init()

    let updateProfile: Observable<User> = inputs.updateProfile
      .flatMapLatest { [weak self] (parameter: Parameter.UpdateProfile) -> Observable<User> in
        return self?.userService
          .updateProfile(parameter: parameter)
          .asObservable()
          .suppressError(observer: errorObserver) ?? .empty()
      }

    return .init(
      presentAlert: presentAlert.asDriver(onErrorDriveWith: .empty()),
      isUpdatingProfile: isUpdatingProfile,
      sections: sections.asDriver(onErrorDriveWith: .empty()),
      updateProfile: updateProfile.asDriver(onErrorDriveWith: .empty())
    )
  }
}
