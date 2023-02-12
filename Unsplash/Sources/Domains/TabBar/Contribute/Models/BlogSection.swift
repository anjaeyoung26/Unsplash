//
//  BlogSection.swift
//  Unsplash
//
//  Created by 안재영 on 2023/02/11.
//

import RxDataSources


struct BlogSection: SectionModelType {

  // MARK: - Properties

  var items: [Blog]


  // MARK: - Initializers

  init(items: [Blog]) {
    self.items = items
  }

  init(original: BlogSection, items: [Blog]) {
    self = original
    self.items = items
  }
}
