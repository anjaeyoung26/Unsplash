//
//  UserSection.swift
//  Unsplash
//
//  Created by ėėŽė on 2023/01/25.
//

import RxDataSources


struct UserSection: SectionModelType {

  // MARK: - Properties

  var items: [User]


  // MARK: - Initializers

  init(items: [User]) {
    self.items = items
  }

  init(original: UserSection, items: [User]) {
    self = original
    self.items = items
  }
}
