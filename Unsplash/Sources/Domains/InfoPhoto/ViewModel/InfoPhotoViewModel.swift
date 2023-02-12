//
//  InfoPhotoViewModel.swift
//  Unsplash
//
//  Created by 안재영 on 2023/01/15.
//

import RxCocoa
import RxSwift


final class InfoPhotoViewModel: ViewModelType {

  // MARK: - Defines

  struct Inputs {
    let requestInfo: Observable<Photo>
  }

  struct Outputs {
    let sections: Driver<[InfoPhotoSection]>
  }


  // MARK: - Properties

  private let disposeBag: DisposeBag = .init()


  // MARK: - Transform

  func transform(inputs: Inputs) -> Outputs {
    let sections: Observable<[InfoPhotoSection]> = inputs.requestInfo
      .map { (photo: Photo) -> [InfoPhotoSection] in
        return [
          .init(items: [
            .exifMake(photo.exif?.make ?? "-"),
            .exifFocalLength(photo.exif?.focalLength ?? "-"),
            .exifModel(photo.exif?.model ?? "-"),
            .exifISO(photo.exif?.iso ?? "-"),
            .exifShutterSpeed(photo.exif?.exposureTime ?? "-"),
            .dimensions(photo.width, photo.height),
            .exifAperture(photo.exif?.aperture ?? "-"),
            .publishedAt(photo.publishedAt ?? "-")
          ])
        ]
      }

    return .init(
      sections: sections.asDriver(onErrorDriveWith: .empty())
    )
  }
}
