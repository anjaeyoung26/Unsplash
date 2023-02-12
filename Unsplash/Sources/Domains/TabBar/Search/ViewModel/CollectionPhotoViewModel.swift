//
//  CollectionPhotoViewModel.swift
//  Unsplash
//
//  Created by 안재영 on 2023/01/28.
//

import Foundation
import RxCocoa
import RxSwift


final class CollectionPhotoViewModel: ViewModelType {

  // MARK: - Defines

  struct Inputs {
    let requestCollectionPhotos: Observable<String>
    let requestDeleteCollectionSheet: Observable<String>
  }

  struct Outputs {
    let deleteCollection: Driver<Void>
    let photos: Driver<[Photo]>
    let presentAlert: Driver<RxAlert<Void>>
    let presentDeleteCollectionSheet: Driver<RxObservableAlert<Bool>>
  }

  private struct Subject {
    let isDeleteCollection: PublishSubject<Bool> = .init()
    let error: PublishSubject<Error> = .init()
  }


  // MARK: - Properties

  private var collectionID: String?

  private let disposeBag: DisposeBag = .init()

  private let subject: Subject = .init()

  private let collectionService: CollectionServiceType


  // MARK: - Initializers

  init(collectionService: CollectionServiceType) {
    self.collectionService = collectionService
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

    let deleteCollectionObserver: AnyObserver<Bool> = self.subject.isDeleteCollection.asObserver()

    let requestDeleteCollection: Observable<String> = self.subject
      .isDeleteCollection
      .filter { (isDeleteCollection: Bool) -> Bool in return isDeleteCollection }
      .compactMap { [weak self] _ -> String? in return self?.collectionID }

    let deleteCollection: Observable<Void> = requestDeleteCollection
      .flatMapLatest { [weak self] (id: String) -> Observable<Response.UpdateCollection> in
        return self?.collectionService
          .deleteCollection(id: id)
          .asObservable()
          .suppressError(observer: errorObserver) ?? .empty()
      }
      .map { _ in }

    let presentDeleteCollectionSheet: Observable<RxObservableAlert<Bool>> = inputs
      .requestDeleteCollectionSheet
      .do(onNext: { [weak self] (id: String) in self?.collectionID = id })
      .map { _  -> RxObservableAlert<Bool> in
        return .init(
          alert: .init(
            actions: [
              .init(style: .destructive, title: "Delete Collection", value: true),
              .init(style: .cancel, title: "Cancel", value: false)
            ],
            message: "Are you sure?",
            style: .actionSheet,
            title: nil
          ),
          observer: deleteCollectionObserver
        )
      }

    let photos: Observable<[Photo]> = inputs.requestCollectionPhotos
      .flatMapLatest { [weak self] (id: String) -> Observable<[Photo]> in
        return self?.collectionService
          .collectionPhotos(parameter: .init(id: id))
          .asObservable()
          .suppressError(observer: errorObserver) ?? .empty()
      }

    return .init(
      deleteCollection: deleteCollection.asDriver(onErrorDriveWith: .empty()),
      photos: photos.asDriver(onErrorDriveWith: .empty()),
      presentAlert: presentAlert.asDriver(onErrorDriveWith: .empty()),
      presentDeleteCollectionSheet: presentDeleteCollectionSheet.asDriver(onErrorDriveWith: .empty())
    )
  }
}
