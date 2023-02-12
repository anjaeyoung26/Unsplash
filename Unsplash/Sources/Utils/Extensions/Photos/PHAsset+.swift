//
//  PHAsset+.swift
//  Unsplash
//
//  Created by 안재영 on 2023/01/06.
//

import Photos
import RxSwift


extension PHAsset {

  func requestImageProperties(resultHandler: @escaping ([CFString: Any]) -> Void) {
    let options: PHImageRequestOptions = .init()
    options.isNetworkAccessAllowed = true

    PHCachingImageManager.default().requestImageDataAndOrientation(
      for: self,
      options: options,
      resultHandler: { (data: Data?, _, _, _) in
        if let data: Data = data,
           let imageSource: CGImageSource = CGImageSourceCreateWithData(data as CFData, nil),
           let imageProperties: [CFString: Any] = CGImageSourceCopyPropertiesAtIndex(imageSource, 0, nil) as? [CFString: Any] {
          resultHandler(imageProperties)
        } else {
          resultHandler([:])
        }
      }
    )
  }
}


// MARK: - Reactive

extension Reactive where Base: PHAsset {

  func requestImageProperties() -> Observable<[CFString: Any]> {
    return .create { (observer: AnyObserver<[CFString : Any]>) -> Disposable in
      base.requestImageProperties { (dictionary: [CFString : Any]) in
        observer.onNext(dictionary)
      }
      return Disposables.create()
    }
  }
}
