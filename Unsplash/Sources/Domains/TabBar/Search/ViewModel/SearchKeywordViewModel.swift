//
//  SearchKeywordViewModel.swift
//  Unsplash
//
//  Created by 안재영 on 2023/01/19.
//

import Foundation
import RxCocoa
import RxSwift


final class SearchKeywordViewModel: ViewModelType {

  // MARK: - Defines

  struct Inputs {
    let requestCategoryPhotos: Observable<String>
  }

  struct Outputs {
    let categoryPhotos: Driver<[Photo]>
    let presentAlert: Driver<RxAlert<Void>>
  }

  private struct Subject {
    let error: PublishSubject<Error> = .init()
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

    let categoryPhotos: Observable<[Photo]> = inputs.requestCategoryPhotos
      .flatMapLatest { [weak self] (title: String) -> Observable<Response.SearchPhotos> in
        return self?.photoService
          .searchPhotos(parameter: .init(query: title, numberOfItems: 20))
          .asObservable()
          .suppressError(observer: errorObserver) ?? .empty()
      }
      .map { (response: Response.SearchPhotos) -> [Photo] in return response.results }

    return .init(
      categoryPhotos: categoryPhotos.asDriver(onErrorDriveWith: .empty()),
      presentAlert: presentAlert.asDriver(onErrorDriveWith: .empty())
    )
  }
}

