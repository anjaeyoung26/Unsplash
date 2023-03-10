//
//  LoggingPlugin.swift
//  Unsplash
//
//  Created by ėėŽė on 2022/12/27.
//

import Foundation
import Moya


final class LoggingPlugin: PluginType {

  // MARK: - Methods

  func willSend(_ request: RequestType, target: TargetType) {
    print("\n")
    print("ð LoggingPlugin - Request")
    print(
      "â URL: \(request.request?.url?.absoluteString ?? "") \n" +
      "â Headers: \(request.request?.allHTTPHeaderFields ?? [:]) \n" +
      "â Method: \(request.request?.httpMethod ?? "") \n"
    )

    if let body = request.request?.httpBody?.prettyPrinted {
      print("â Body: \(body) \n")
    }
  }

  func didReceive(_ result: Result<Moya.Response, MoyaError>, target: TargetType) {
    print("\n")
    print("ð° LoggingPlugin - Response")

    switch result {
    case .success(let response):
      print(
        "â URL: \(response.request?.url?.absoluteString ?? "") \n" +
        "â X-Ratelimit-Limit: \(response.rateLimit ?? "") \n" +
        "â X-Ratelimit-Remaining: \(response.rateRemaining ?? "") \n" +
        "â StatusCode: \(response.response?.statusCode ?? 0) \n" +
        "â Data: \(response.data.prettyPrinted ?? "") \n"
      )

    case .failure(let error):
      print(
        "â URL: \(error.response?.request?.url?.absoluteString ?? "") \n" +
        "â X-Ratelimit-Limit: \(error.response?.rateLimit ?? "") \n" +
        "â X-Ratelimit-Remaining: \(error.response?.rateRemaining ?? "") \n" +
        "â StatusCode: \(error.response?.response?.statusCode ?? 0) \n" +
        "â Error: \(error.localizedDescription)"
      )
    }
  }
}


// MARK: - Data Extension (Private)

private extension Data {

  var prettyPrinted: String? {
    if let object = try? JSONSerialization.jsonObject(with: self, options: [.mutableContainers]),
       let jsonData = try? JSONSerialization.data(withJSONObject: object, options: [.prettyPrinted]) {
      return .init(data: jsonData, encoding: .utf8)
    }
    return nil
  }
}


// MARK: - Moya.Response Extension (Private)

private extension Moya.Response {

  var rateLimit: String? {
    return self.response?.value(forHTTPHeaderField: "x-ratelimit-limit")
  }

  var rateRemaining: String? {
    return self.response?.value(forHTTPHeaderField: "x-ratelimit-remaining")
  }
}
