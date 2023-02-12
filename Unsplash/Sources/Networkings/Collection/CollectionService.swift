//
//  CollectionService.swift
//  Unsplash
//
//  Created by 안재영 on 2023/02/07.
//

import Foundation
import Moya
import RxMoya
import RxSwift


protocol CollectionServiceType {

  // MARK: - Methods

  func addPhoto(parameter: Parameter.UpdatePhotoToCollection) -> Single<Response.UpdateCollection>

  func collectionPhotos(parameter: Parameter.CollectionPhotos) -> Single<[Photo]>

  func createCollection(parameter: Parameter.CreateCollection) -> Single<Collection>

  func deleteCollection(id: String) -> Single<Response.UpdateCollection>

  func removePhoto(parameter: Parameter.UpdatePhotoToCollection) -> Single<Response.UpdateCollection>

  func updateCollection(parameter: Parameter.UpdateCollection) -> Single<Collection>
}


// MARK: - CollectionService

final class CollectionService: CollectionServiceType {

  // MARK: - Properties

  private let disposeBag: DisposeBag = .init()

  let networking: Networking<CollectionAPI>


  // MARK: - Initializers

  init(networking: Networking<CollectionAPI>) {
    self.networking = networking
  }


  // MARK: - Methods

  func addPhoto(
    parameter: Parameter.UpdatePhotoToCollection
  ) -> Single<Response.UpdateCollection> {
    return self.networking.rx
      .request(.addPhoto(parameter))
      .map(Response.UpdateCollection.self)
  }

  func collectionPhotos(parameter: Parameter.CollectionPhotos) -> Single<[Photo]> {
    return self.networking.rx
      .request(.collectionPhotos(parameter))
      .map([Photo].self)
  }

  func createCollection(parameter: Parameter.CreateCollection) -> Single<Collection> {
    return self.networking.rx
      .request(.createCollection(parameter))
      .map(Collection.self)
  }

  func deleteCollection(id: String) -> Single<Response.UpdateCollection> {
    return self.networking.rx
      .request(.deleteCollection(id: id))
      .map(Response.UpdateCollection.self)
  }

  func removePhoto(
    parameter: Parameter.UpdatePhotoToCollection
  ) -> Single<Response.UpdateCollection> {
    return self.networking.rx
      .request(.removePhoto(parameter))
      .map(Response.UpdateCollection.self)
  }

  func updateCollection(parameter: Parameter.UpdateCollection) -> Single<Collection> {
    return self.networking.rx
      .request(.updateCollection(parameter))
      .map(Collection.self)
  }
}

