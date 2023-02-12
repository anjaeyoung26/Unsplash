//
//  UIImagePickerController+.swift
//  Unsplash
//
//  Created by 안재영 on 2023/01/04.
//

import RxCocoa
import RxSwift
import UIKit


extension Reactive where Base: UIImagePickerController {

  var didFinishPickingMediaWithInfo: Observable<[UIImagePickerController.InfoKey: AnyObject]> {
    return self.delegate
      .methodInvoked(#selector(UIImagePickerControllerDelegate.imagePickerController(_:didFinishPickingMediaWithInfo:)))
      .map { (info: [Any]) -> [UIImagePickerController.InfoKey: AnyObject] in
        guard let value = info[1] as? [UIImagePickerController.InfoKey: AnyObject] else {
          throw RxCocoaError.castingError(
            object: info[1],
            targetType: [UIImagePickerController.InfoKey: AnyObject].self
          )
        }
        return value
      }
  }

  var didCancel: Observable<Void> {
    return self.delegate
      .methodInvoked(#selector(UIImagePickerControllerDelegate.imagePickerControllerDidCancel(_:)))
      .map { _ in }
  }

  static func createWithParent(
    _ parent: UIViewController?,
    animated: Bool = true,
    configureImagePicker: @escaping (UIImagePickerController) throws -> Void
  ) -> Observable<UIImagePickerController> {
    return .create { [weak parent] (
      observer: AnyObserver<UIImagePickerController>
    ) -> Disposable in
      let imagePickerController: UIImagePickerController = .init()
      let cancelDisposable: Disposable = imagePickerController.rx
        .didCancel
        .subscribe(onNext: { [weak imagePickerController] _ in
          imagePickerController?.dismiss(animated: animated)
        })

      do {
        try configureImagePicker(imagePickerController)
      } catch {
        observer.on(.error(error))
        return Disposables.create()
      }

      guard let parent: UIViewController = parent else {
        observer.on(.completed)
        return Disposables.create()
      }

      parent.present(imagePickerController, animated: animated, completion: nil)
      observer.on(.next(imagePickerController))

      return Disposables.create([cancelDisposable])
    }
  }
}

