//
//  ProfileViewModel.swift
//  Unsplash
//
//  Created by 안재영 on 2022/12/30.
//

import RxCocoa
import RxOptional
import RxSwift


final class ProfileViewModel: ViewModelType {

  // MARK: - Defines

  struct Inputs {
    let requestActivityItem: Observable<User?>
    let requestOtherProfile: Observable<User>
    let requestMyProfile: Observable<User>
    let requestLogOut: Observable<Void>
  }

  struct Outputs {
    let collectionSections: Driver<[CollectionSection]>
    let isCollectionEmpty: Driver<Bool>
    let isLikePhotoEmpty: Driver<Bool>
    let isLoadingProfile: RxActivityIndicator
    let isUserPhotoEmpty: Driver<Bool>
    let likePhotos: Driver<[Photo]>
    let logOut: Driver<Void>
    let presentActivity: Driver<ProfileActivityItemSource>
    let presentAlert: Driver<RxAlert<Void>>
    let userPhotos: Driver<[Photo]>
  }

  private struct Subject {
    let isCollectionEmpty: PublishSubject<Bool> = .init()
    let isLikePhotoEmpty: PublishSubject<Bool> = .init()
    let isUserPhotoEmpty: PublishSubject<Bool> = .init()
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

    let me: Observable<User> = inputs.requestMyProfile.share(replay: 1)

    let requestMyProfile: Observable<String> = me
      .map { (user: User) -> String in return user.userName }

    let requestOtherProfile: Observable<String> = inputs.requestOtherProfile
      .map { (user: User) -> String in return user.userName }

    let requestProfile: Observable<String> = Observable<String>
      .merge(requestOtherProfile, requestMyProfile)
      .share(replay: 1)

    let isLoadingProfile: RxActivityIndicator = .init()

    let isCollectionEmpty: AnyObserver<Bool> = self.subject.isCollectionEmpty.asObserver()

    let collectionSections: Observable<[CollectionSection]> = requestProfile
      .flatMapLatest { [weak self] (userName: String) -> Observable<List<Collection>> in
        return self?.userService
          .userCollections(parameter: .init(userName: userName))
          .asObservable()
          .trackActivity(isLoadingProfile)
          .suppressError(observer: errorObserver) ?? .empty()
      }
      .map { (list: List<Collection>) -> [CollectionSection] in
        isCollectionEmpty.onNext(list.items.isEmpty)
        return [.init(items: list.items)]
      }

    let isLikePhotoEmpty: AnyObserver<Bool> = self.subject.isLikePhotoEmpty.asObserver()

    let likePhotos: Observable<[Photo]> = requestProfile
      .flatMapLatest { [weak self] (userName: String) -> Observable<List<Photo>> in
        return self?.userService
          .likePhotos(parameter: .init(userName: userName))
          .asObservable()
          .trackActivity(isLoadingProfile)
          .suppressError(observer: errorObserver) ?? .empty()
      }
      .map { (list: List<Photo>) -> [Photo] in
        isLikePhotoEmpty.onNext(list.items.isEmpty)
        return list.items
      }

    let isUserPhotoEmpty: AnyObserver<Bool> = self.subject.isUserPhotoEmpty.asObserver()

    let userPhotos: Observable<[Photo]> = requestProfile
      .flatMapLatest { [weak self] (userName: String) -> Observable<[Photo]> in
        return self?.userService
          .userPhotos(parameter: .init(userName: userName))
          .asObservable()
          .trackActivity(isLoadingProfile)
          .suppressError(observer: errorObserver) ?? .empty()
      }
      .map { (photos: [Photo]) -> [Photo] in
        isUserPhotoEmpty.onNext(photos.isEmpty)
        return photos
      }

    let presentActivity: Observable<ProfileActivityItemSource> = inputs.requestActivityItem
      .catchOnNil { return me }
      .compactMap { (user: User) -> ProfileActivityItemSource in return .init(user: user) }

    let logOut: Observable<Void> = inputs.requestLogOut
      .map { [weak self] _ in try self?.keychainService.deleteToken() }

    return .init(
      collectionSections: collectionSections.asDriver(onErrorDriveWith: .empty()),
      isCollectionEmpty: self.subject.isCollectionEmpty.asDriver(onErrorDriveWith: .empty()),
      isLikePhotoEmpty: self.subject.isLikePhotoEmpty.asDriver(onErrorDriveWith: .empty()),
      isLoadingProfile: isLoadingProfile,
      isUserPhotoEmpty: self.subject.isUserPhotoEmpty.asDriver(onErrorDriveWith: .empty()),
      likePhotos: likePhotos.asDriver(onErrorDriveWith: .empty()),
      logOut: logOut.asDriver(onErrorDriveWith: .empty()),
      presentActivity: presentActivity.asDriver(onErrorDriveWith: .empty()),
      presentAlert: presentAlert.asDriver(onErrorDriveWith: .empty()),
      userPhotos: userPhotos.asDriver(onErrorDriveWith: .empty())
    )
  }
}

