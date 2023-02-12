//
//  EditCollectionViewModel.swift
//  Unsplash
//
//  Created by 안재영 on 2023/02/08.
//

import Foundation
import RxCocoa
import RxSwift


final class EditCollectionViewModel: ViewModelType {

  // MARK: - Defines

  struct Inputs {
    let requestSections: Observable<Collection?>
    let createCollection: Observable<Parameter.CreateCollection>
    let updateCollection: Observable<Parameter.UpdateCollection>
  }

  struct Outputs {
    let editedCollection: Driver<Collection>
    let presentAlert: Driver<RxAlert<Void>>
    let sections: Driver<[EditCollectionSection]>
  }

  private struct Subject {
    let error: PublishSubject<Error> = .init()
  }


  // MARK: - Properties

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

    let sections: Observable<[EditCollectionSection]> = inputs.requestSections
      .map { (collection: Collection?) -> [EditCollectionSection] in
        return [
          .init(items: [
            .title(collection?.title),
            .description(collection?.description),
            .isPrivate(collection?.isPrivate ?? true)
          ])
        ]
      }

    let createCollection: Observable<Collection> = inputs.createCollection
      .flatMapLatest { [weak self] (parameter: Parameter.CreateCollection) -> Observable<Collection> in
        return self?.collectionService
          .createCollection(parameter: parameter)
          .asObservable()
          .suppressError(observer: errorObserver) ?? .empty()
      }

    let updateCollection: Observable<Collection> = inputs.updateCollection
      .flatMapLatest { [weak self] (parameter: Parameter.UpdateCollection) -> Observable<Collection> in
        return self?.collectionService
          .updateCollection(parameter: parameter)
          .asObservable()
          .suppressError(observer: errorObserver) ?? .empty()
      }

    let editedCollection: Observable<Collection> = .merge(createCollection, updateCollection)

    return .init(
      editedCollection: editedCollection.asDriver(onErrorDriveWith: .empty()),
      presentAlert: presentAlert.asDriver(onErrorDriveWith: .empty()),
      sections: sections.asDriver(onErrorDriveWith: .empty())
    )
  }
}
