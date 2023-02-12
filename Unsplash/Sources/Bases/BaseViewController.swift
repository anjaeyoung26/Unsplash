//
//  BaseViewController.swift
//  Unsplash
//
//  Created by 안재영 on 2022/12/27.
//

import RxCocoa
import RxSwift
import UIKit


class BaseViewController: UIViewController {

  // MARK: - Properties

  var disposeBag: DisposeBag = .init()


  // MARK: - Initializers

  init() {
    super.init(nibName: nil, bundle: nil)

    self.bind()
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }


  // MARK: - Life Cycle

  override func viewDidLoad() {
    super.viewDidLoad()

    self.addSubviews()
    self.setConstraints()
    self.setComponents()
    self.setNavigationBar()
    self.view.backgroundColor = .black
  }
  

  // MARK: - Layout

  func addSubviews() {

  }

  func setConstraints() {

  }

  func setComponents() {

  }

  func setNavigationBar() {
    self.navigationItem.backButtonDisplayMode = .minimal
  }


  // MARK: - Bind

  func bind() {

  }
}


// MARK: - Reactive

extension Reactive where Base: BaseViewController {

  var presentAlert: Binder<RxAlert<Void>> {
    return Binder<RxAlert<Void>>(self.base) { (
      viewController: BaseViewController,
      alert: RxAlert<Void>
    ) in
      alert
        .present(at: viewController, animated: true)
        .drive()
        .disposed(by: viewController.disposeBag)
    }
  }

  var presentObservableBooleanAlert: Binder<RxObservableAlert<Bool>> {
    return Binder<RxObservableAlert<Bool>>(self.base) { (
      viewController: BaseViewController,
      alert: RxObservableAlert<Bool>
    ) in
      alert.present(at: viewController, animated: true)
    }
  }

  var presentImagePicker: Observable<[UIImagePickerController.InfoKey: AnyObject]> {
    return UIImagePickerController.rx
      .createWithParent(
        base,
        animated: true,
        configureImagePicker: { (picker: UIImagePickerController) in
          picker.sourceType = .photoLibrary
          picker.allowsEditing = false
        }
      )
      .flatMapLatest { (
        picker: UIImagePickerController
      ) -> Observable<[UIImagePickerController.InfoKey: AnyObject]> in
        return picker.rx.didFinishPickingMediaWithInfo
      }
  }
}
