//
//  SampleDataFetcher.swift
//  Unsplash
//
//  Created by ėėŽė on 2022/12/27.
//

import Foundation
import Moya


protocol SampleDataFetcher {

  // MARK: - Defines

  associatedtype API = TargetType


  // MARK: - Methods

  static func fetch(target: API) -> Data
}
