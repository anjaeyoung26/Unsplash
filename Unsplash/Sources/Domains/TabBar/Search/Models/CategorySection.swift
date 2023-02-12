//
//  CategorySection.swift
//  Unsplash
//
//  Created by 안재영 on 2023/01/19.
//

import RxDataSources


struct CategorySection: SectionModelType {

  // MARK: - Properties

  var items: [Category]


  // MARK: - Initializers

  init(items: [Category]) {
    self.items = items
  }

  init(original: CategorySection, items: [Category]) {
    self = original
    self.items = items
  }
}
