//
//  Setting.swift
//  Unsplash
//
//  Created by ėėŽė on 2022/12/27.
//

struct Setting {

  // MARK: - Properties

  @UserDefaultsWrapper("didTapStartBrowsingInOnboarding", defaultValue: false)
  static var didTapStartBrowsingInOnboarding: Bool

  @UserDefaultsWrapper("recentSearchQueries", defaultValue: [])
  static var recentSearchQueries: [String]
}
