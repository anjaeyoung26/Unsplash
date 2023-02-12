//
//  MKLocalSearch+.swift
//  Unsplash
//
//  Created by 안재영 on 2023/01/08.
//

import MapKit
import RxSwift


extension Reactive where Base: MKLocalSearch {

  func start() -> Observable<MKLocalSearch.Response> {
    return .create { (observer: AnyObserver<MKLocalSearch.Response>) -> Disposable in
      base.start { (response: MKLocalSearch.Response?, error: Error?) in
        if let response = response {
          observer.onNext(response)
        } else if let error = error {
          observer.onError(error)
        } else {
          observer.onError(RxError.noElements)
        }
      }
      return Disposables.create()
    }
  }
}
