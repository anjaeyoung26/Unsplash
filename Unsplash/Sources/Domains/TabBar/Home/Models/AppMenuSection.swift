//
//  AppMenuSection.swift
//  Unsplash
//
//  Created by ėėŽė on 2023/01/01.
//

import RxDataSources


struct AppMenuSection: SectionModelType {

  // MARK: - Properties

  var items: [AppMenuSectionItem]


  // MARK: - Initializers

  init(items: [AppMenuSectionItem]) {
    self.items = items
  }

  init(original: AppMenuSection, items: [AppMenuSectionItem]) {
    self = original
    self.items = items
  }
}
