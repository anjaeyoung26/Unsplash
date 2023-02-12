//
//  PhotoSection.swift
//  Unsplash
//
//  Created by 안재영 on 2022/12/28.
//

import Foundation
import RxDataSources


struct PhotoSection: SectionModelType {

  // MARK: - Properties

  var items: [Photo]


  // MARK: - Initializers

  init(items: [Photo]) {
    self.items = items
  }

  init(original: PhotoSection, items: [Photo]) {
    self = original
    self.items = items
  }
}
