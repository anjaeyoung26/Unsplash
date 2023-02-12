//
//  TrackActivity.swift
//  Unsplash
//
//  Created by 안재영 on 2023/01/17.
//

import Foundation
import RxCocoa
import RxSwift


private struct ActivityToken<E> : ObservableConvertibleType, Disposable {

  // MARK: - Properties

  private let source: Observable<E>

  private let disposable: Cancelable


  // MARK: - Initializers

  init(source: Observable<E>, disposeAction: @escaping () -> Void) {
    self.source = source
    self.disposable = Disposables.create(with: disposeAction)
  }


  // MARK: - Methods

  func dispose() {
    self.disposable.dispose()
  }

  func asObservable() -> Observable<E> {
    return self.source
  }
}


// MARK: - RxActivityIndicator

class RxActivityIndicator: SharedSequenceConvertibleType {

  // MARK: - Defines

  typealias Element = Bool

  typealias SharingStrategy = DriverSharingStrategy


  // MARK: - Properties

  private let lock: NSRecursiveLock = .init()

  private let relay: BehaviorRelay<Int> = .init(value: 0)

  private let loading: SharedSequence<SharingStrategy, Bool>


  // MARK: - Initializers

  init() {
    self.loading = self.relay.asDriver()
      .map { (value: Int) -> Bool in return value > 0 }
      .distinctUntilChanged()
  }


  // MARK: - Methods

  fileprivate func trackActivityOfObservable<Source: ObservableConvertibleType>(
    _ source: Source
  ) -> Observable<Source.Element> {
    return .using { () -> ActivityToken<Source.Element> in
      self.increment()
      return ActivityToken(source: source.asObservable(), disposeAction: self.decrement)
    } observableFactory: { (token: ActivityToken<Source.Element>) in
      return token.asObservable()
    }
  }

  private func increment() {
    self.lock.lock()
    self.relay.accept(self.relay.value + 1)
    self.lock.unlock()
  }

  private func decrement() {
    self.lock.lock()
    self.relay.accept(self.relay.value - 1)
    self.lock.unlock()
  }

  func asSharedSequence() -> SharedSequence<SharingStrategy, Element> {
    return self.loading
  }
}


// MARK: - Extension ObservableConvertibleType

extension ObservableConvertibleType {
  
  func trackActivity(_ activityIndicator: RxActivityIndicator) -> Observable<Element> {
    return activityIndicator.trackActivityOfObservable(self)
  }
}
