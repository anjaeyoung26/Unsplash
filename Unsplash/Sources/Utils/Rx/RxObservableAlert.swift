//
//  RxObservableAlert.swift
//  Unsplash
//
//  Created by 안재영 on 2023/02/07.
//

import RxSwift
import UIKit


struct RxObservableAlert<T> {

  // MARK: - Properties

  private let alert: RxAlert<T>

  private let disposeBag: DisposeBag = .init()

  let observer: AnyObserver<T>


  // MARK: - Initializers

  init(
    alert: RxAlert<T>,
    observer: AnyObserver<T>
  ) {
    self.alert = alert
    self.observer = observer
  }


  // MARK: - Functions

  func present(at controller: UIViewController?, animated: Bool) {
    self.alert
      .present(at: controller, animated: animated)
      .drive(self.observer)
      .disposed(by: self.disposeBag)
  }
}
