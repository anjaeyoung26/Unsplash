//
//  UserDefaultsWrapper.swift
//  Unsplash
//
//  Created by 안재영 on 2022/12/27.
//

import Foundation


@propertyWrapper
struct UserDefaultsWrapper<T> {

  // MARK: - Properties

  let key: String
  
  let defaultValue: T

  var wrappedValue: T {
    get { return UserDefaults.standard.object(forKey: key) as? T ?? defaultValue }
    set { return UserDefaults.standard.set(newValue, forKey: key) }
  }


  // MARK: - Initializers

  init(_ key: String, defaultValue: T) {
    self.key = key
    self.defaultValue = defaultValue
  }
}
