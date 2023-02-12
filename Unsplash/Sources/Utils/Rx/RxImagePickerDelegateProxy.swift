//
//  RxImagePickerDelegateProxy.swift
//  Unsplash
//
//  Created by 안재영 on 2023/01/04.
//

import RxCocoa
import RxSwift
import UIKit


final class RxImagePickerDelegateProxy:
  RxNavigationControllerDelegateProxy,
  UIImagePickerControllerDelegate
{

  // MARK: - Initializers

  init(imagePickerController: UIImagePickerController) {
    super.init(navigationController: imagePickerController)
  }

}
