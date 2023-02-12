//
//  Networking.swift
//  Unsplash
//
//  Created by 안재영 on 2022/12/27.
//

import Moya


final class Networking<Target: TargetType>: MoyaProvider<Target> {

  // MARK: - Initializers

  init(stubClosure: @escaping StubClosure, plugins: [PluginType]) {
    super.init(stubClosure: stubClosure, plugins: plugins)
  }
}
