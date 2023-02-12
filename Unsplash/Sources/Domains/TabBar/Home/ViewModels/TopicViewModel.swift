//
//  TopicViewModel.swift
//  Unsplash
//
//  Created by 안재영 on 2023/01/02.
//

import Foundation
import RxCocoa
import RxSwift


final class TopicViewModel: ViewModelType {

  // MARK: - Defines

  struct Inputs {
    let requestTopicPhotos: Observable<String>
    let requestMoreTopicPhotos: Observable<Void>
  }

  struct Outputs {
    let presentAlert: Driver<RxAlert<Void>>
    let sections: Driver<[PhotoSection]>
  }

  private struct Subject {
    let error: PublishSubject<Error> = .init()
    let nextURL: PublishSubject<URL> = .init()
    let photos: BehaviorSubject<[Photo]> = .init(value: [])
  }


  // MARK: - Properties

  private let disposeBag: DisposeBag = .init()

  private let subject: Subject = .init()

  private let photoService: PhotoServiceType

  private let topicService: TopicServiceType


  // MARK: - Initializers

  init(photoService: PhotoServiceType, topicService: TopicServiceType) {
    self.photoService = photoService
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

    let topicPhotos: Observable<List<Photo>> = inputs.requestTopicPhotos
      .flatMapLatest { [weak self] (id: String) -> Observable<List<Photo>> in
        return self?.topicService
          .photos(parameter: .init(idOrSlug: id))
          .asObservable()
          .suppressError(observer: errorObserver) ?? .empty()
      }
      .share(replay: 1)

    let morePhotos: Observable<List<Photo>> = inputs.requestMoreTopicPhotos
      .withLatestFrom(self.subject.nextURL)
      .flatMapLatest { [weak self] (url: URL) -> Observable<List<Photo>> in
        return self?.photoService
          .listPhoto(url)
          .asObservable()
          .suppressError(observer: errorObserver) ?? .empty()
      }
      .share(replay: 1)

    let sections: Observable<[PhotoSection]> = self.subject.photos
      .map { (photos: [Photo]) -> [PhotoSection] in return [.init(items: photos)] }

    Observable<[Photo]>
      .merge(
        topicPhotos.map { (list: List<Photo>) -> [Photo] in return list.items },
        morePhotos.map { (list: List<Photo>) -> [Photo] in return list.items }
      )
      .withLatestFrom(self.subject.photos) { (
        newPhotos: [Photo],
        currentPhotos: [Photo]
      ) -> [Photo] in
        return currentPhotos + newPhotos
      }
      .bind(to: self.subject.photos)
      .disposed(by: self.disposeBag)

    Observable<List<Photo>>
      .merge(topicPhotos, morePhotos)
      .compactMap { (list: List<Photo>) -> URL? in return list.nextURL }
      .bind(to: self.subject.nextURL)
      .disposed(by: self.disposeBag)

    return .init(
      presentAlert: presentAlert.asDriver(onErrorDriveWith: .empty()),
      sections: sections.asDriver(onErrorDriveWith: .empty())
    )
  }
}
