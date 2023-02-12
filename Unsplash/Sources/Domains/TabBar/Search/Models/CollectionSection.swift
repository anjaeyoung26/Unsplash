//
//  CollectionSection.swift
//  Unsplash
//
//  Created by 안재영 on 2023/01/25.
//

import RxDataSources


struct CollectionSection: SectionModelType {

  // MARK: - Properties

  var items: [Collection]


  // MARK: - Initializers

  init(items: [Collection]) {
    self.items = items
  }

  init(original: CollectionSection, items: [Collection]) {
    self = original
    self.items = items
  }
}
