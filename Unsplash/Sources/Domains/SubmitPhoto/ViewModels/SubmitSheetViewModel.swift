//
//  SubmitSheetViewModel.swift
//  Unsplash
//
//  Created by 안재영 on 2023/01/04.
//

import Photos
import RxCocoa
import RxSwift


final class SubmitSheetViewModel: ViewModelType {

  // MARK: - Defines

  struct Inputs {
    let requestTopicPhotos: Observable<String>
    let submitPhoto: Observable<Void>
  }

  struct Outputs {
    let openSetting: Driver<Void>
    let presentAlert: Driver<RxAlert<Void>>
    let presentNotAuthorizedAlert: Driver<RxObservableAlert<Bool>>
    let presentImagePicker: Observable<Void>
    let sections: Driver<[PhotoSection]>
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

    let authorizationStatus: Observable<PHAuthorizationStatus> = inputs.submitPhoto
      .flatMapLatest { _ -> Observable<PHAuthorizationStatus> in
        return RxPhotoAlbum.requestAuthorization(level: .readWrite)
      }
      .share(replay: 1)

    let notAuthorized: Observable<Void> = authorizationStatus
      .filter { (status: PHAuthorizationStatus) -> Bool in return status != .authorized }
      .map { _ in }

    let openSettingObserver: AnyObserver<Bool> = self.subject.isOpenSetting.asObserver()

    let openSetting: Observable<Void> = self.subject.isOpenSetting
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

    let photos: Observable<[Photo]> = inputs.requestTopicPhotos
      .flatMapLatest { [weak self] (id: String) -> Observable<List<Photo>> in
        return self?.topicService
          .photos(parameter: .init(idOrSlug: id, numberOfItems: 4))
          .asObservable()
          .suppressError(observer: errorObserver) ?? .empty()
      }
      .map { (list: List<Photo>) -> [Photo] in return list.items }

    let sections: Observable<[PhotoSection]> = photos
      .map { (photos: [Photo]) -> [PhotoSection] in return [.init(items: photos)] }

    return .init(
      openSetting: openSetting.asDriver(onErrorDriveWith: .empty()),
      presentAlert: presentAlert.asDriver(onErrorDriveWith: .empty()),
      presentNotAuthorizedAlert: presentNotAuthorizedAlert.asDriver(onErrorDriveWith: .empty()),
      presentImagePicker: presentImagePicker,
      sections: sections.asDriver(onErrorDriveWith: .empty())
    )
  }
}
