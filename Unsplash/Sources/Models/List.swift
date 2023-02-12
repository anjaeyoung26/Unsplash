//
//  List.swift
//  Unsplash
//
//  Created by 안재영 on 2022/12/28.
//

import Foundation


struct List<Item> {

  // MARK: - Properties

  var items: [Item]

  var nextURL: URL?


  // MARK: - Initializers

  init(items: [Item], nextURL: URL? = nil) {
    self.items = items
    self.nextURL = nextURL
  }
}
