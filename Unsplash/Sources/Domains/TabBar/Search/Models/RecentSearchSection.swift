//
//  RecentSearchSection.swift
//  Unsplash
//
//  Created by 안재영 on 2023/01/22.
//

import RxDataSources


struct RecentSearchSection: SectionModelType {

  // MARK: - Properties

  var items: [RecentSearchSectionItem]

  var title: String?

  var hideClearButton: Bool


  // MARK: - Initializers

  init(items: [RecentSearchSectionItem], title: String?, hideClearbutton: Bool = false) {
    self.items = items
    self.title = title
    self.hideClearButton = hideClearbutton
  }

  init(original: RecentSearchSection, items: [RecentSearchSectionItem]) {
    self = original
    self.items = items
  }
}
