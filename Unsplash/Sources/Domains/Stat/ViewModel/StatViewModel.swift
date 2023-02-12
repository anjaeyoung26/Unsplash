//
//  StatViewModel.swift
//  Unsplash
//
//  Created by 안재영 on 2023/01/31.
//

import Foundation
import RxCocoa
import RxSwift


final class StatViewModel: ViewModelType {

  // MARK: - Defines

  struct Inputs {
    let requestMyStat: Observable<User>
    let requestPopularPhotos: Observable<User>
  }

  struct Outputs {
    let popularPhotoSections: Driver<[PhotoSection]>
    let presentAlert: Driver<RxAlert<Void>>
    let isPopularPhotoEmpty: Driver<Bool>
    let stat: Driver<Stat>
  }

  private struct Subject {
    let isPopularPhotoEmpty: PublishSubject<Bool> = .init()
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

    let isPopularPhotoEmpty: AnyObserver<Bool> = self.subject.isPopularPhotoEmpty.asObserver()

    let popularPhotoSections: Observable<[PhotoSection]> = inputs.requestPopularPhotos
      .flatMapLatest { [weak self] (user: User) -> Observable<[Photo]> in
        return self?.userService
          .userPhotos(parameter: .init(
            userName: user.userName,
            numberOfItems: 3,
            orderBy: .popular
          ))
          .asObservable()
          .suppressError(observer: errorObserver) ?? .empty()
      }
      .map { (photos: [Photo]) -> [PhotoSection] in
        isPopularPhotoEmpty.onNext(photos.isEmpty)
        return [.init(items: photos)]
      }

    let stat: Observable<Stat> = inputs.requestMyStat
      .flatMapLatest { [weak self] (user: User) -> Observable<Stat> in
        return self?.userService
          .stat(parameter: .init(userName: user.userName))
          .asObservable()
          .suppressError(observer: errorObserver) ?? .empty()
      }

    return .init(
      popularPhotoSections: popularPhotoSections.asDriver(onErrorDriveWith: .empty()),
      presentAlert: presentAlert.asDriver(onErrorDriveWith: .empty()),
      isPopularPhotoEmpty: self.subject.isPopularPhotoEmpty.asDriver(onErrorDriveWith: .empty()),
      stat: stat.asDriver(onErrorDriveWith: .empty())
    )
  }
}
