//
//  AccountSettingSection.swift
//  Unsplash
//
//  Created by 안재영 on 2023/02/06.
//

import RxDataSources


struct AccountSettingSection: SectionModelType {

  // MARK: - Properties

  var items: [AccountSettingSectionItem]


  // MARK: - Initializers

  init(items: [AccountSettingSectionItem]) {
    self.items = items
  }

  init(original: AccountSettingSection, items: [AccountSettingSectionItem]) {
    self = original
    self.items = items
  }
}
