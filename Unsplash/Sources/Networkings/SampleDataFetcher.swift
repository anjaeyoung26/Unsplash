//
//  SampleDataFetcher.swift
//  Unsplash
//
//  Created by 안재영 on 2022/12/27.
//

import Foundation
import Moya


protocol SampleDataFetcher {

  // MARK: - Defines

  associatedtype API = TargetType


  // MARK: - Methods

  static func fetch(target: API) -> Data
}
