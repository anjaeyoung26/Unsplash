//
//  EditCollectionSection.swift
//  Unsplash
//
//  Created by 안재영 on 2023/02/08.
//

import RxDataSources


struct EditCollectionSection: SectionModelType {

  // MARK: - Properties

  var items: [EditCollectionSectionItem]


  // MARK: - Initializers

  init(items: [EditCollectionSectionItem]) {
    self.items = items
  }

  init(original: EditCollectionSection, items: [EditCollectionSectionItem]) {
    self = original
    self.items = items
  }
}
