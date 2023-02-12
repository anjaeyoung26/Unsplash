//
//  PhotoService.swift
//  Unsplash
//
//  Created by 안재영 on 2022/12/27.
//

import Foundation
import Moya
import RxMoya
import RxSwift


protocol PhotoServiceType {

  // MARK: - Properties

  var networking: Networking<PhotoAPI> { get }


  // MARK: - Methods

  func downloadURL(id: String) -> Single<Photo.Download>

  func like(id: String) -> Single<Response.LikePhoto>

  func list(parameter: Parameter.ListPhotos) -> Single<List<Photo>>

  func random(parameter: Parameter.RandomPhotos) -> Single<[Photo]>

  func searchCollections(parameter: Parameter.SearchCollections) -> Single<Response.SearchCollections>

  func searchPhotos(parameter: Parameter.SearchPhotos) -> Single<Response.SearchPhotos>

  func searchUsers(parameter: Parameter.SearchUsers) -> Single<Response.SearchUsers>

  func single(id: String) -> Single<Photo>

  func unlike(id: String) -> Single<Response.LikePhoto>

  func upload(
    parameter: Parameter.UploadPhoto,
    progressObserver: AnyObserver<Double>
  ) -> Observable<Photo>

  func listCollection(_ url: URL) -> Single<List<Collection>>

  func listPhoto(_ url: URL) -> Single<List<Photo>>
}


// MARK: - PhotoService

final class PhotoService: PhotoServiceType {

  // MARK: - Properties

  private let disposeBag: DisposeBag = .init()

  let networking: Networking<PhotoAPI>


  // MARK: - Initializers

  init(networking: Networking<PhotoAPI>) {
    self.networking = networking
  }


  // MARK: - Methods

  func downloadURL(id: String) -> Single<Photo.Download> {
    return self.networking.rx
      .request(.downloadURL(id: id))
      .map(Photo.Download.self)
  }

  func like(id: String) -> Single<Response.LikePhoto> {
    return self.networking.rx
      .request(.like(id: id))
      .map(Response.LikePhoto.self)
  }

  func list(parameter: Parameter.ListPhotos) -> Single<List<Photo>> {
    return self.networking.rx
      .request(.list(parameter))
      .map(List<Photo>.self)
  }

  func random(parameter: Parameter.RandomPhotos) -> Single<[Photo]> {
    return self.networking.rx
      .request(.random(parameter))
      .map([Photo].self)
  }

  func searchCollections(parameter: Parameter.SearchCollections) -> Single<Response.SearchCollections> {
    return self.networking.rx
      .request(.searchCollections(parameter))
      .map(Response.SearchCollections.self)
  }

  func searchPhotos(parameter: Parameter.SearchPhotos) -> Single<Response.SearchPhotos> {
    return self.networking.rx
      .request(.searchPhotos(parameter))
      .map(Response.SearchPhotos.self)
  }

  func searchUsers(parameter: Parameter.SearchUsers) -> Single<Response.SearchUsers> {
    return self.networking.rx
      .request(.searchUsers(parameter))
      .map(Response.SearchUsers.self)
  }

  func single(id: String) -> Single<Photo> {
    return self.networking.rx
      .request(.single(id: id))
      .map(Photo.self)
  }

  func unlike(id: String) -> Single<Response.LikePhoto> {
    return self.networking.rx
      .request(.unlike(id: id))
      .map(Response.LikePhoto.self)
  }

  func upload(
    parameter: Parameter.UploadPhoto,
    progressObserver: AnyObserver<Double>
  ) -> Observable<Photo> {
    return self.networking.rx
      .requestWithProgress(.upload(parameter))
      .compactMap { (response: Moya.ProgressResponse) -> Moya.Response? in
        progressObserver.onNext(response.progress)
        return response.response
      }
      .map(Photo.self)
  }

  func listCollection(_ url: URL) -> Single<List<Collection>> {
    return self.networking.rx
      .request(.url(url))
      .map(List<Collection>.self)
  }

  func listPhoto(_ url: URL) -> Single<List<Photo>> {
    return self.networking.rx
      .request(.url(url))
      .map(List<Photo>.self)
  }
}
