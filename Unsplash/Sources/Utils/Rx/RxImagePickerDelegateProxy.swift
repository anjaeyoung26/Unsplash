//
//  RxImagePickerDelegateProxy.swift
//  Unsplash
//
//  Created by ėėŽė on 2023/01/04.
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
