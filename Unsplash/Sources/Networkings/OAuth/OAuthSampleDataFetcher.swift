//
//  OAuthSampleDataFetcher.swift
//  Unsplash
//
//  Created by ėėŽė on 2022/12/30.
//

import Foundation
import Moya


final class OAuthSampleDataFetcher: SampleDataFetcher {

  // MARK: - Methods

  static func fetch(target: OAuthAPI) -> Data {
    switch target {
    case .token:
      return """

      """.data(using: .utf8)!
    }
  }
}
