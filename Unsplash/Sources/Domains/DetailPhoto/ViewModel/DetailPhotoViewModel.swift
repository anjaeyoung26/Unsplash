//
//  DetailPhotoViewModel.swift
//  Unsplash
//
//  Created by 안재영 on 2023/01/11.
//

import Foundation
import LinkPresentation
import RxCocoa
import RxSwift


final class DetailPhotoViewModel: ViewModelType {

  // MARK: - Defines

  struct Inputs {
    let requestActivityItem: Observable<Void>
    let requestDetailPhoto: Observable<String>
    let downloadPhoto: Observable<URL>
    let likePhoto: Observable<String>
    let unlikePhoto: Observable<String>
  }

  struct Outputs {
    let detailPhoto: Driver<Photo>
    let isDownloadingPhoto: RxActivityIndicator
    let isPhotoDownloaded: Driver<Bool>
    let likedByUser: Driver<Bool>
    let presentActivity: Driver<PhotoActivityItemSource>
    let presentAlert: Driver<RxAlert<Void>>
    let relatedPhotos: Driver<[Photo]>
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

    let photo: Observable<Photo> = inputs.requestDetailPhoto
      .flatMapLatest { [weak self] (id: String) -> Observable<Photo> in
        return self?.photoService
          .single(id: id)
          .asObservable()
          .suppressError(observer: errorObserver) ?? .empty()
      }
      .share(replay: 1)

    let presentActivity: Observable<PhotoActivityItemSource> = inputs.requestActivityItem
      .withLatestFrom(photo)
      .map { (photo: Photo) -> PhotoActivityItemSource in return .init(photo: photo) }

    let relatedPhotos: Observable<[Photo]> = photo
      .compactMap { (photo: Photo) -> Photo.Tag? in return photo.tags?.first }
      .flatMapLatest { [weak self] (tag: Photo.Tag) -> Observable<Response.SearchPhotos> in
        return self?.photoService
          .searchPhotos(parameter: .init(query: tag.title))
          .asObservable()
          .suppressError(observer: errorObserver) ?? .empty()
      }
      .map { (response: Response.SearchPhotos) -> [Photo] in return response.results }

    let isDownloadingPhoto: RxActivityIndicator = .init()

    let photoData: Observable<UIImage> = inputs.downloadPhoto
      .flatMapLatest { (url: URL) -> Observable<Data> in
        return URLSession.shared.rx
          .data(request:. init(url: url))
          .asObservable()
          .trackActivity(isDownloadingPhoto)
          .suppressError(observer: errorObserver)
      }
      .compactMap { (data: Data) -> UIImage? in return .init(data: data) }

    let downloadPhoto: Observable<Bool> = photoData
      .flatMapLatest { (image: UIImage) -> Observable<Bool> in
        return RxPhotoAlbum
          .download(image: image)
          .trackActivity(isDownloadingPhoto)
          .suppressError(observer: errorObserver)
      }

    let likePhoto: Observable<Response.LikePhoto> = inputs.likePhoto
      .flatMapLatest { [weak self] (id: String) -> Observable<Response.LikePhoto> in
        return self?.photoService
          .like(id: id)
          .asObservable()
          .suppressError(observer: errorObserver) ?? .empty()
      }

    let unlikePhoto: Observable<Response.LikePhoto> = inputs.unlikePhoto
      .flatMapLatest { [weak self] (id: String) -> Observable<Response.LikePhoto> in
        return self?.photoService
          .unlike(id: id)
          .asObservable()
          .suppressError(observer: errorObserver) ?? .empty()
      }

    let likedByUser: Observable<Bool> = Observable<Response.LikePhoto>
      .merge(likePhoto, unlikePhoto)
      .compactMap { (response: Response.LikePhoto) -> Bool? in return response.photo.likedByUser }

    return .init(
      detailPhoto: photo.asDriver(onErrorDriveWith: .empty()),
      isDownloadingPhoto: isDownloadingPhoto,
      isPhotoDownloaded: downloadPhoto.asDriver(onErrorDriveWith: .empty()),
      likedByUser: likedByUser.asDriver(onErrorDriveWith: .empty()),
      presentActivity: presentActivity.asDriver(onErrorDriveWith: .empty()),
      presentAlert: presentAlert.asDriver(onErrorDriveWith: .empty()),
      relatedPhotos: relatedPhotos.asDriver(onErrorDriveWith: .empty())
    )
  }
}
