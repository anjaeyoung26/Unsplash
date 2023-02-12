//
//  SearchResultViewModel.swift
//  Unsplash
//
//  Created by 안재영 on 2023/01/25.
//

import Foundation
import RxCocoa
import RxSwift


final class SearchResultViewModel: ViewModelType {

  // MARK: - Defines

  struct Inputs {
    let searchCollections: Observable<String>
    let searchPhotos: Observable<String>
    let searchUsers: Observable<String>
  }

  struct Outputs {
    let collectionSections: Driver<[CollectionSection]>
    let photos: Driver<[Photo]>
    let userSections: Driver<[UserSection]>
    let isSearchCollectionEmpty: Driver<Bool>
    let isSearchPhotoEmpty: Driver<Bool>
    let isSearchUserEmpty: Driver<Bool>
    let isSearching: RxActivityIndicator
  }

  private struct Subject {
    let isSearchCollectionEmpty: PublishSubject<Bool> = .init()
    let isSearchPhotoEmpty: PublishSubject<Bool> = .init()
    let isSearchUserEmpty: PublishSubject<Bool> = .init()
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
    let isSearching: RxActivityIndicator = .init()

    let isSearchCollectionEmpty: AnyObserver<Bool> = self.subject.isSearchCollectionEmpty.asObserver()

    let collectionSections: Observable<[CollectionSection]> = inputs.searchCollections
      .flatMapLatest { [weak self] (query: String) -> Observable<Response.SearchCollections> in
        return self?.photoService
          .searchCollections(parameter: .init(query: query))
          .asObservable()
          .trackActivity(isSearching) ?? .empty()
      }
      .map { (response: Response.SearchCollections) -> [CollectionSection] in
        isSearchCollectionEmpty.onNext(response.results.isEmpty)
        return [.init(items: response.results)]
      }

    let isSearchPhotoEmpty: AnyObserver<Bool> = self.subject.isSearchPhotoEmpty.asObserver()

    let photos: Observable<[Photo]> = inputs.searchPhotos
      .flatMapLatest { [weak self] (query: String) -> Observable<Response.SearchPhotos> in
        return self?.photoService
          .searchPhotos(parameter: .init(query: query, numberOfItems: 20))
          .asObservable()
          .trackActivity(isSearching) ?? .empty()
      }
      .map { (response: Response.SearchPhotos) -> [Photo] in
        isSearchPhotoEmpty.onNext(response.results.isEmpty)
        return response.results
      }

    let isSearchUserEmpty: AnyObserver<Bool> = self.subject.isSearchUserEmpty.asObserver()

    let userSections: Observable<[UserSection]> = inputs.searchUsers
      .flatMapLatest { [weak self] (query: String) -> Observable<Response.SearchUsers> in
        return self?.photoService
          .searchUsers(parameter: .init(query: query))
          .asObservable()
          .trackActivity(isSearching) ?? .empty()
      }
      .map { (response: Response.SearchUsers) -> [UserSection] in
        isSearchUserEmpty.onNext(response.results.isEmpty)
        return [.init(items: response.results)]
      }

    return .init(
      collectionSections: collectionSections.asDriver(onErrorDriveWith: .empty()),
      photos: photos.asDriver(onErrorDriveWith: .empty()),
      userSections: userSections.asDriver(onErrorDriveWith: .empty()),
      isSearchCollectionEmpty: self.subject.isSearchCollectionEmpty.asDriver(onErrorDriveWith: .empty()),
      isSearchPhotoEmpty: self.subject.isSearchPhotoEmpty.asDriver(onErrorDriveWith: .empty()),
      isSearchUserEmpty: self.subject.isSearchUserEmpty.asDriver(onErrorDriveWith: .empty()),
      isSearching: isSearching
    )
  }
}
