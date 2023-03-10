//
//  SubmitPhotoSection.swift
//  Unsplash
//
//  Created by ėėŽė on 2023/01/05.
//

import RxDataSources


struct SubmitPhotoSection: SectionModelType {

  // MARK: - Properties

  var items: [SubmitPhotoSectionItem]

  var title: String?


  // MARK: - Initializers

  init(items: [SubmitPhotoSectionItem], title: String?) {
    self.items = items
    self.title = title
  }

  init(original: SubmitPhotoSection, items: [SubmitPhotoSectionItem]) {
    self = original
    self.items = items
  }
}
