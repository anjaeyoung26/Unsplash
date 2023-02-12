//
//  PrimitiveSequence+.swift
//  Unsplash
//
//  Created by 안재영 on 2023/01/18.
//

import Foundation
import Moya
import RxSwift


extension PrimitiveSequence where Trait == SingleTrait {

  func debugDecodingError() -> PrimitiveSequence<Trait, Element> {
    return self
      .catchError { (error: Error) -> PrimitiveSequence<Trait, Element> in
        var object: Any
        switch error {
        case let DecodingError.dataCorrupted(context):
          object = "codingPath: \(context.codingPath)"
        case let DecodingError.keyNotFound(key, context):
          object = "Key \(key) not found: \(context.debugDescription), " +
                   "codingPath: \(context.codingPath)"
        case let DecodingError.valueNotFound(value, context):
          object = "Value \(value) not found: \(context.debugDescription), " +
                   "codingPath: \(context.codingPath)"
        case let DecodingError.typeMismatch(type, context):
          object = "Type \(type) mismatch: \(context.debugDescription), " +
                   "codingPath: \(context.codingPath)"
        default:
          object = error
        }
        
        Logger.log(level: .error, object: object)
        return self
      }
  }
}


// MARK: - Moya.Response

extension PrimitiveSequence where Trait == SingleTrait, Element == Moya.Response {

  func map<Model: Decodable>(_ list: List<Model>.Type) -> PrimitiveSequence<Trait, List<Model>> {
    return self
      .map { (response: Moya.Response) -> List<Model> in
        let items: [Model] = try JSONDecoder().decode([Model].self, from: response.data)
        let nextURL: URL? = Self.findNextURL(response: response)
        return .init(items: items, nextURL: nextURL)
      }
  }

  private static func findNextURL(response: Moya.Response) -> URL? {
    guard let linkString: String = response.response?.allHeaderFields["Link"] as? String else {
      return nil
    }

    return linkString
      .components(separatedBy: ",")
      .map { (linkString: String) -> String in
        return linkString.trimmingCharacters(in: .whitespacesAndNewlines)
      }
      .compactMap { (component: String) -> URL? in
        guard let urlString: String = self.firstMatch(in: component, pattern: "^<(.*)>"),
              let relation: String = self.firstMatch(in: component, pattern: "rel=\"(.*)\""),
              relation == "next" else { return nil }
        return .init(string: urlString)
      }
      .first
  }

  private static func firstMatch(in string: String, pattern: String) -> String? {
    let range: NSRange = .init(location: 0, length: string.count)
    guard let regex: NSRegularExpression = try? .init(pattern: pattern),
          let result: NSTextCheckingResult = regex.firstMatch(in: string, range: range) else {
      return nil
    }
    return (string as NSString).substring(with: result.range(at: 1))
  }
}
