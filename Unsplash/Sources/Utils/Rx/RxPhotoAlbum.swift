//
//  RxPhotoAlbum.swift
//  Unsplash
//
//  Created by 안재영 on 2023/01/18.
//

import Photos
import RxSwift
import UIKit


final class RxPhotoAlbum {

  // MARK: - Methods

  static func download(image: UIImage) -> Observable<Bool> {
    return .create { (observer: AnyObserver<Bool>) -> Disposable in
      PHPhotoLibrary.shared().performChanges {
        PHAssetChangeRequest.creationRequestForAsset(from: image)
      } completionHandler: { (isDownloaded: Bool, error: Error?) in
        if let error: Error = error {
          observer.onError(error)
        } else {
          observer.onNext(isDownloaded)
          observer.onCompleted()
        }
      }
      return Disposables.create()
    }
  }

  static func requestAuthorization(level: PHAccessLevel) -> Observable<PHAuthorizationStatus> {
    return .create { (observer: AnyObserver<PHAuthorizationStatus>) -> Disposable in
      PHPhotoLibrary.requestAuthorization(for: level) { (status: PHAuthorizationStatus) in
        observer.onNext(status)
        observer.onCompleted()
      }
      return Disposables.create()
    }
  }

  static func authorizationStatus(level: PHAccessLevel) -> Observable<PHAuthorizationStatus> {
    return .create { (observer: AnyObserver<PHAuthorizationStatus>) -> Disposable in
      observer.onNext(PHPhotoLibrary.authorizationStatus(for: level))
      observer.onCompleted()
      return Disposables.create()
    }
  }
}
