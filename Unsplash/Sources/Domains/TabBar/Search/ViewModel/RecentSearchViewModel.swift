//
//  RecentSearchViewModel.swift
//  Unsplash
//
//  Created by 안재영 on 2023/01/22.
//

import Foundation
import RxCocoa
import RxSwift


final class RecentSearchViewModel: ViewModelType {

  // MARK: - Defines

  struct Inputs {
    let clearRecentSearchQueries: Observable<Void>
    let requestSections: Observable<Void>
  }

  struct Outputs {
    let sections: Driver<[RecentSearchSection]>
  }


  // MARK: - Properties

  private let disposeBag: DisposeBag = .init()


  // MARK: - Transform

  func transform(inputs: Inputs) -> Outputs {
    let reloadSections: Observable<Void> = inputs.clearRecentSearchQueries
      .map { _ -> Void in Setting.recentSearchQueries.removeAll() }

    let sections: Observable<[RecentSearchSection]> = Observable<Void>
      .merge(reloadSections, inputs.requestSections)
      .map { _ -> [RecentSearchSection] in
        var sections: [RecentSearchSection] = []

        let recentSearchQueries: [String] = Setting.recentSearchQueries
        if !recentSearchQueries.isEmpty {
          let recentSection: RecentSearchSection = .init(
            items: recentSearchQueries.map(RecentSearchSectionItem.recent),
            title: "Recent"
          )
          sections.append(recentSection)
        }

        let trends: [String] = SearchTrend.allCases.map(\.rawValue)
        let trendingSection: RecentSearchSection = .init(
          items: trends.map(RecentSearchSectionItem.trending),
          title: "Trending",
          hideClearbutton: true
        )

        sections.append(trendingSection)
        return sections
      }

    return .init(
      sections: sections.asDriver(onErrorDriveWith: .empty())
    )
  }
}
