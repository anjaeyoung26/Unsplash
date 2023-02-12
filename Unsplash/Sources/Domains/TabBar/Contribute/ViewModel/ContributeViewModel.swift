//
//  ContributeViewModel.swift
//  Unsplash
//
//  Created by 안재영 on 2023/01/06.
//

import Photos
import RxCocoa
import RxSwift


final class ContributeViewModel: ViewModelType {

  // MARK: - Defines

  struct Inputs {
    let requestBlogs: Observable<Void>
    let requestTopics: Observable<Void>
    let uploadPhoto: Observable<Void>
  }

  struct Outputs {
    let blogSections: Driver<[BlogSection]>
    let openSetting: Driver<Void>
    let isLoadingTopics: RxActivityIndicator
    let presentAlert: Driver<RxAlert<Void>>
    let presentNotAuthorizedAlert: Driver<RxObservableAlert<Bool>>
    let presentImagePicker: Observable<Void>
    let topicSections: Driver<[TopicSection]>
  }

  private struct Subject {
    let error: PublishSubject<Error> = .init()
    let isOpenSetting: PublishSubject<Bool> = .init()
  }


  // MARK: - Properties

  private let disposeBag: DisposeBag = .init()

  private let subject: Subject = .init()

  private let topicService: TopicServiceType


  // MARK: - Initializers

  init(topicService: TopicServiceType) {
    self.topicService = topicService
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

    let blogSections: Observable<[BlogSection]> = inputs.requestBlogs
      .map { _ -> [Blog] in return Blog.allCases }
      .map { (blogs: [Blog]) -> [BlogSection] in return [.init(items: blogs)] }

    let authorizationStatus: Observable<PHAuthorizationStatus> = inputs.uploadPhoto
      .flatMapLatest { _ -> Observable<PHAuthorizationStatus> in
        return RxPhotoAlbum.requestAuthorization(level: .readWrite)
      }
      .share(replay: 1)

    let notAuthorized: Observable<Void> = authorizationStatus
      .filter { (status: PHAuthorizationStatus) -> Bool in return status != .authorized }
      .map { _ in }

    let openSettingObserver: AnyObserver<Bool> = self.subject.isOpenSetting.asObserver()

    let openSetting: Observable<Void> = self.subject
      .isOpenSetting
      .filter { (isOpenSetting: Bool) -> Bool in return isOpenSetting }
      .map { _ in }

    let presentNotAuthorizedAlert: Observable<RxObservableAlert<Bool>> = notAuthorized
      .map { _ -> RxObservableAlert<Bool> in
        return .init(
          alert: .init(
            actions: [
              .init(style: .default, title: "NO", value: false),
              .init(style: .default, title: "OK", value: true)
            ],
            message: "Would you like to allow it in the settings?",
            title: "Permission to access your photo library is not granted."
          ),
          observer: openSettingObserver
        )
      }

    let presentImagePicker: Observable<Void> = authorizationStatus
      .filter { (status: PHAuthorizationStatus) -> Bool in return status == .authorized }
      .map { _ in }

    let isLoadingTopics: RxActivityIndicator = .init()

    let topicSections: Observable<[TopicSection]> = inputs.requestTopics
      .flatMapLatest { [weak self] _ -> Observable<List<Topic>> in
        return self?.topicService
          .list(parameter: .init(numberOfItems: 20))
          .asObservable()
          .trackActivity(isLoadingTopics)
          .suppressError(observer: errorObserver) ?? .empty()
      }
      .map { (list: List<Topic>) -> [Topic] in return list.items }
      .map { (topics: [Topic]) -> [TopicSection] in return [.init(items: topics)] }

    return .init(
      blogSections: blogSections.asDriver(onErrorDriveWith: .empty()),
      openSetting: openSetting.asDriver(onErrorDriveWith: .empty()),
      isLoadingTopics: isLoadingTopics,
      presentAlert: presentAlert.asDriver(onErrorDriveWith: .empty()),
      presentNotAuthorizedAlert: presentNotAuthorizedAlert.asDriver(onErrorDriveWith: .empty()),
      presentImagePicker: presentImagePicker,
      topicSections: topicSections.asDriver(onErrorDriveWith: .empty())
    )
  }
}
