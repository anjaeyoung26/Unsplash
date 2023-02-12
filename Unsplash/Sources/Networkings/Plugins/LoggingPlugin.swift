//
//  LoggingPlugin.swift
//  Unsplash
//
//  Created by 안재영 on 2022/12/27.
//

import Foundation
import Moya


final class LoggingPlugin: PluginType {

  // MARK: - Methods

  func willSend(_ request: RequestType, target: TargetType) {
    print("\n")
    print("🚀 LoggingPlugin - Request")
    print(
      "∘ URL: \(request.request?.url?.absoluteString ?? "") \n" +
      "∘ Headers: \(request.request?.allHTTPHeaderFields ?? [:]) \n" +
      "∘ Method: \(request.request?.httpMethod ?? "") \n"
    )

    if let body = request.request?.httpBody?.prettyPrinted {
      print("∘ Body: \(body) \n")
    }
  }

  func didReceive(_ result: Result<Moya.Response, MoyaError>, target: TargetType) {
    print("\n")
    print("🛰 LoggingPlugin - Response")

    switch result {
    case .success(let response):
      print(
        "∘ URL: \(response.request?.url?.absoluteString ?? "") \n" +
        "∘ X-Ratelimit-Limit: \(response.rateLimit ?? "") \n" +
        "∘ X-Ratelimit-Remaining: \(response.rateRemaining ?? "") \n" +
        "∘ StatusCode: \(response.response?.statusCode ?? 0) \n" +
        "∘ Data: \(response.data.prettyPrinted ?? "") \n"
      )

    case .failure(let error):
      print(
        "∘ URL: \(error.response?.request?.url?.absoluteString ?? "") \n" +
        "∘ X-Ratelimit-Limit: \(error.response?.rateLimit ?? "") \n" +
        "∘ X-Ratelimit-Remaining: \(error.response?.rateRemaining ?? "") \n" +
        "∘ StatusCode: \(error.response?.response?.statusCode ?? 0) \n" +
        "∘ Error: \(error.localizedDescription)"
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
