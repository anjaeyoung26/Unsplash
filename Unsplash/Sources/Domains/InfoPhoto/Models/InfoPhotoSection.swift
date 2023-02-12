//
//  InfoPhotoSection.swift
//  Unsplash
//
//  Created by 안재영 on 2023/01/15.
//

import RxDataSources


struct InfoPhotoSection: SectionModelType {

  // MARK: - Properties

  var items: [InfoPhotoSectionItem]


  // MARK: - Initializers

  init(items: [InfoPhotoSectionItem]) {
    self.items = items
  }

  init(original: InfoPhotoSection, items: [InfoPhotoSectionItem]) {
    self = original
    self.items = items
  }
}
