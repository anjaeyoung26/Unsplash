//
//  AddToCollectionViewModel.swift
//  Unsplash
//
//  Created by 안재영 on 2023/02/07.
//

import Foundation
import RxCocoa
import RxSwift


final class AddToCollectionViewModel: ViewModelType {

  // MARK: - Defines

  struct Inputs {
    let addPhotoToCollection: Observable<Parameter.UpdatePhotoToCollection>
    let removePhotoInCollection: Observable<Parameter.UpdatePhotoToCollection>
    let requestUserCollections: Observable<User>
  }

  struct Outputs {
    let collectionSections: Driver<[CollectionSection]>
    let isLoadingSections: RxActivityIndicator
    let presentAlert: Driver<RxAlert<Void>>
    let updateCollection: Driver<Collection>
  }

  private struct Subject {
    let error: PublishSubject<Error> = .init()
  }


  // MARK: - Properties

  private let disposeBag: DisposeBag = .init()

  private let subject: Subject = .init()

  private let collectionService: CollectionServiceType

  private let userService: UserServiceType


  // MARK: - Initializers

  init(
    collectionService: CollectionServiceType,
    userService: UserServiceType
  ) {
    self.collectionService = collectionService
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

    let addPhotoToCollection: Observable<Response.UpdateCollection> = inputs.addPhotoToCollection
      .flatMapLatest { [weak self] (
        parameter: Parameter.UpdatePhotoToCollection
      ) -> Observable<Response.UpdateCollection> in
        return self?.collectionService
          .addPhoto(parameter: parameter)
          .asObservable()
          .suppressError(observer: errorObserver) ?? .empty()
      }

    let removePhotoInCollection: Observable<Response.UpdateCollection> = inputs.removePhotoInCollection
      .flatMapLatest { [weak self] (
        parameter: Parameter.UpdatePhotoToCollection
      ) -> Observable<Response.UpdateCollection> in
        return self?.collectionService
          .removePhoto(parameter: parameter)
          .asObservable()
          .suppressError(observer: errorObserver) ?? .empty()
      }

    let updateCollection: Observable<Collection> = Observable<Response.UpdateCollection>
      .merge(addPhotoToCollection, removePhotoInCollection)
      .map { (response: Response.UpdateCollection) -> Collection in return response.collection }

    let isLoadingSections: RxActivityIndicator = .init()

    let collectionSections: Observable<[CollectionSection]> = inputs.requestUserCollections
      .flatMapLatest { [weak self] (user: User) -> Observable<List<Collection>> in
        return self?.userService
          .userCollections(parameter: .init(userName: user.userName))
          .asObservable()
          .trackActivity(isLoadingSections)
          .suppressError(observer: errorObserver) ?? .empty()
      }
      .map { (list: List<Collection>) -> [CollectionSection] in return [.init(items: list.items)] }

    return .init(
      collectionSections: collectionSections.asDriver(onErrorDriveWith: .empty()),
      isLoadingSections: isLoadingSections,
      presentAlert: presentAlert.asDriver(onErrorDriveWith: .empty()),
      updateCollection: updateCollection.asDriver(onErrorDriveWith: .empty())
    )
  }
}
