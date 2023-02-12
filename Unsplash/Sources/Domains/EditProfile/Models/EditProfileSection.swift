//
//  EditProfileSection.swift
//  Unsplash
//
//  Created by 안재영 on 2023/02/07.
//

import RxDataSources


struct EditProfileSection: SectionModelType {

  // MARK: - Properties

  var items: [EditProfileSectionItem]

  var title: String?


  // MARK: - Initializers

  init(items: [EditProfileSectionItem], title: String?) {
    self.items = items
    self.title = title
  }

  init(original: EditProfileSection, items: [EditProfileSectionItem]) {
    self = original
    self.items = items
  }
}
