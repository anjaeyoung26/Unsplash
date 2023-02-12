//
//  SubmitPhotoViewModel.swift
//  Unsplash
//
//  Created by 안재영 on 2023/01/04.
//

import Photos
import RxCocoa
import RxSwift
import UIKit


final class SubmitPhotoViewModel: ViewModelType {

  // MARK: - Defines

  struct Inputs {
    let requestSections: Observable<PHAsset>
    let uploadPhoto: Observable<Parameter.UploadPhoto>
  }

  struct Outputs {
    let presentAlert: Driver<RxAlert<Void>>
    let sections: Driver<[SubmitPhotoSection]>
    let uploadComplete: Driver<Photo>
    let uploadProgress: Driver<Double>
  }

  private struct Subject {
    let error: PublishSubject<Error> = .init()
    let uploadProgress: PublishSubject<Double> = .init()
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

    let exif: Observable<Photo.Exif> = inputs.requestSections
      .flatMapLatest { (asset: PHAsset?) -> Observable<[CFString: Any]> in
        return asset?.rx
          .requestImageProperties()
          .suppressError(observer: errorObserver) ?? .empty()
      }
      .map { (dictionary: [CFString: Any]) -> Photo.Exif in return .init(dictionary: dictionary) }
      .share(replay: 1)

    let sections: Observable<[SubmitPhotoSection]> = exif
      .map { (exif: Photo.Exif) -> [SubmitPhotoSection] in
        var sections: [SubmitPhotoSection] = [
          .init(items: [.description], title: "DESCRIPTION"),
          .init(items: [.location], title: "LOCATION"),
          .init(items: [.tags], title: "TAGS"),
          .init(items: [.showOnProfile], title: nil)
        ]

        let exifSectionItems: [SubmitPhotoSectionItem] = [
          exif.make.map(SubmitPhotoSectionItem.exifMake),
          exif.model.map(SubmitPhotoSectionItem.exifModel),
          exif.focalLength.map(SubmitPhotoSectionItem.exifFocalLength),
          exif.aperture.map(SubmitPhotoSectionItem.exifAperture),
          exif.exposureTime.map(SubmitPhotoSectionItem.exifShutterSpeed),
          exif.iso.map(SubmitPhotoSectionItem.exifISO)
        ]
          .compactMap { (item: SubmitPhotoSectionItem?) -> SubmitPhotoSectionItem? in return item }

        sections.insert(.init(items: exifSectionItems, title: "EXIF"), at: 3)
        return sections
      }

    let uploadProgressObserver: AnyObserver<Double> = self.subject.uploadProgress.asObserver()
    
    let uploadPhoto: Observable<Photo> = inputs.uploadPhoto
      .withLatestFrom(exif) { (
        parameter: Parameter.UploadPhoto,
        exif: Photo.Exif
      ) -> (Parameter.UploadPhoto, Photo.Exif) in
        return (parameter, exif)
      }
      .flatMapLatest { [weak self] (
        parameter: Parameter.UploadPhoto,
        exif: Photo.Exif
      ) -> Observable<Photo> in
        var parameter: Parameter.UploadPhoto = parameter
        parameter.exif = exif

        return self?.photoService
          .upload(parameter: parameter, progressObserver: uploadProgressObserver)
          .asObservable()
          .suppressError(observer: errorObserver) ?? .empty()
      }

    let uploadComplete: Observable<Photo> = self.subject.uploadProgress
      .filter { (progress: Double) -> Bool in return progress >= 1.0 }
      .withLatestFrom(uploadPhoto)

    return .init(
      presentAlert: presentAlert.asDriver(onErrorDriveWith: .empty()),
      sections: sections.asDriver(onErrorDriveWith: .empty()),
      uploadComplete: uploadComplete.asDriver(onErrorDriveWith: .empty()),
      uploadProgress: self.subject.uploadProgress.asDriver(onErrorDriveWith: .empty())
    )
  }
}
