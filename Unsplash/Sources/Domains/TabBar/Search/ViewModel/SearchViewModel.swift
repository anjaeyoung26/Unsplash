//
//  SearchViewModel.swift
//  Unsplash
//
//  Created by 안재영 on 2023/01/06.
//

import Foundation
import RxCocoa
import RxSwift


final class SearchViewModel: ViewModelType {

  // MARK: - Defines

  struct Inputs {
    let requestCategorySections: Observable<Void>
    let requestDiscoverSections: Observable<Void>
    let requestMoreDiscoverPhotos: Observable<Void>
  }

  struct Outputs {
    let categorySections: Driver<[CategorySection]>
    let discoveredPhotos: Driver<[Photo]>
    let presentAlert: Driver<RxAlert<Void>>
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


  // MARK: - Initializers

  init(photoService: PhotoServiceType) {
    self.photoService = photoService
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

    let categorySections: Observable<[CategorySection]> = inputs.requestCategorySections
      .map { _ -> [CategorySection] in return [.init(items: Category.allCases)]}

    let latestPhotos: Observable<List<Photo>> = inputs.requestDiscoverSections
      .flatMapLatest { [weak self] _ -> Observable<List<Photo>> in
        return self?.photoService
          .list(parameter: .init(orderBy: .latest))
          .asObservable()
          .suppressError(observer: errorObserver) ?? .empty()
      }
      .share(replay: 1)

    let morePhotos: Observable<List<Photo>> = inputs.requestMoreDiscoverPhotos
      .withLatestFrom(self.subject.nextURL)
      .flatMapLatest { [weak self] (url: URL) -> Observable<List<Photo>> in
        return self?.photoService
          .listPhoto(url)
          .asObservable()
          .suppressError(observer: errorObserver) ?? .empty()
      }
      .share(replay: 1)

    Observable<[Photo]>
      .merge(
        latestPhotos.map { (list: List<Photo>) -> [Photo] in return list.items },
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
      .merge(latestPhotos, morePhotos)
      .compactMap { (list: List<Photo>) -> URL? in return list.nextURL }
      .bind(to: self.subject.nextURL)
      .disposed(by: self.disposeBag)

    return .init(
      categorySections: categorySections.asDriver(onErrorDriveWith: .empty()),
      discoveredPhotos: self.subject.photos.asDriver(onErrorDriveWith: .empty()),
      presentAlert: presentAlert.asDriver(onErrorDriveWith: .empty())
    )
  }
}
