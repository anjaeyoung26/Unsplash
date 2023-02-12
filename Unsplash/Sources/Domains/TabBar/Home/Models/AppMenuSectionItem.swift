//
//  AppMenuSectionItem.swift
//  Unsplash
//
//  Created by 안재영 on 2023/01/01.
//

import Foundation


enum AppMenuSectionItem {
  case summary(AppSummary)
  case feedback(AppFeedback)
  case license(url: URL)
  case recommend(items: [Any])
  case review(url: URL)
  case visit(url: URL)
}
