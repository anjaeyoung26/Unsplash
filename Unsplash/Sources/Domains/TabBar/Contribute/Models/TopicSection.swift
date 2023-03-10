//
//  TopicSection.swift
//  Unsplash
//
//  Created by ėėŽė on 2023/02/10.
//

import RxDataSources


struct TopicSection: SectionModelType {

  // MARK: - Properties

  var items: [Topic]


  // MARK: - Initializers

  init(items: [Topic]) {
    self.items = items
  }

  init(original: TopicSection, items: [Topic]) {
    self = original
    self.items = items
  }
}
