//
//  RxAlert.swift
//  Unsplash
//
//  Created by 안재영 on 2022/12/27.
//

import RxCocoa
import RxSwift
import UIKit


struct RxAlert<T> {

  // MARK: - Defines

  private struct Subject {
    let action: PublishSubject<T> = .init()
  }


  // MARK: - Properties

  let actions: [RxAlertAction<T>]

  let message: String?

  let style: UIAlertController.Style

  let title: String?

  private let subject: Subject = .init()


  // MARK: - Initializers

  init(
    actions: [RxAlertAction<T>],
    message: String?,
    style: UIAlertController.Style = .alert,
    title: String?
  ) {
    self.actions = actions
    self.message = message
    self.style = style
    self.title = title
  }


  // MARK: - Methods

  @discardableResult
  func present(at controller: UIViewController?, animated: Bool) -> Driver<T> {
    return Observable<T>
      .create { [weak controller, self] (observer: AnyObserver<T>) -> Disposable in
        let disposable: Disposable = self.subject.action.bind(to: observer)
        let alertController: UIAlertController = .alert(with: self)
        controller?.present(alertController, animated: animated)

        return Disposables.create { disposable.dispose() }
      }
      .asDriver(onErrorDriveWith: .empty())
  }

  func action(at index: Int) {
    guard self.actions.count > index else { return }
    let value: T = self.actions[index].value
    self.subject.action.onNext(value)
  }
}


// MARK: - RxAlertAction

struct RxAlertAction<T> {

  // MARK: - Properties

  let style: UIAlertAction.Style

  let title: String

  let value: T
}


// MARK: - UIAlertController Private Extension

private extension UIAlertController {

  static func alert<T>(with alert: RxAlert<T>) -> UIAlertController {
    let alertController: UIAlertController = .init(
      title: alert.title,
      message: alert.message,
      preferredStyle: alert.style
    )

    alert.actions
      .enumerated()
      .forEach { [weak alertController] (index: Int, action: RxAlertAction) in
        let alertAction: UIAlertAction = .init(
          title: action.title,
          style: action.style,
          handler: { _ in alert.action(at: index) }
        )
        alertController?.addAction(alertAction)
    }

    return alertController
  }
}
