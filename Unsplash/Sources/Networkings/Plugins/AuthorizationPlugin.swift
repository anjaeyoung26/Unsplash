//
//  AuthorizationPlugin.swift
//  Unsplash
//
//  Created by 안재영 on 2023/02/08.
//

import Foundation
import Moya


final class AuthorizationPlugin: PluginType {

  // MARK: - Properties

  private let keychainService: KeychainServiceType


  // MARK: - Initializers

  init(keychainService: KeychainServiceType) {
    self.keychainService = keychainService
  }


  // MARK: - Methods

  func prepare(_ request: URLRequest, target: TargetType) -> URLRequest {
    var request: URLRequest = request
    var authorizationValue: String

    if let token: Token = self.keychainService.fetchToken() {
      authorizationValue = "Bearer \(token.accessToken)"
    } else {
      authorizationValue = "Client-ID 70JVSFgj47Z68ZHj45z8g8geVTLXEKJpcsY78c5mY6w"
    }

    request.addValue(authorizationValue, forHTTPHeaderField: "Authorization")
    return request
  }
}
