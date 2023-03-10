//
//  RxOperators.swift
//  Unsplash
//
//  Created by ėėŽė on 2022/12/28.
//

import RxSwift


extension ObservableType {

  func suppressError<Observer: ObserverType>(
    observer: Observer
  ) -> Observable<Element> where Observer.Element == Swift.Error {
    return self
      .`do`(onError: { (error: Error) in
        observer.onNext(error)
      })
      .retryWhen { _ -> Observable<Element> in
        return .empty()
      }
  }
}
