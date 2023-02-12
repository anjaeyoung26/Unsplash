//
//  OAuthAPI.swift
//  Unsplash
//
//  Created by 안재영 on 2022/12/30.
//

import Foundation
import Moya


enum OAuthAPI {
  case token(Parameter.Token)
}


// MARK: - TargetType

extension OAuthAPI: TargetType {

  var baseURL: URL {
    return .init(string: "https://unsplash.com/oauth")!
  }

  var headers: [String : String]? {
    return nil
  }

  var method: Moya.Method {
    return .post
  }

  var path: String {
    switch self {
    case .token:
      return "/token"
    }
  }

  var sampleData: Data {
    return OAuthSampleDataFetcher.fetch(target: self)
  }

  var task: Task {
    let parameters: [String: Any] = {
      switch self {
      case .token(let parameter):
        return [
          "client_id": parameter.clientID,
          "client_secret": parameter.clientSecret,
          "redirect_uri": parameter.redirectURI,
          "code": parameter.code,
          "grant_type": parameter.grantType
        ]
      }
    }()
    
    return .requestParameters(parameters: parameters, encoding: URLEncoding.default)
  }
}
