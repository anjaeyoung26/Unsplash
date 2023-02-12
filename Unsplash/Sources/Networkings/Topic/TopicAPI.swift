//
//  TopicAPI.swift
//  Unsplash
//
//  Created by 안재영 on 2023/01/02.
//

import Foundation
import Moya


enum TopicAPI {
  case list(Parameter.ListTopics)
  case photos(Parameter.TopicPhotos)
}


// MARK: - TargetType

extension TopicAPI: TargetType {

  var baseURL: URL {
    return .init(string: "https://api.unsplash.com")!
  }

  var headers: [String : String]? {
    return nil
  }

  var method: Moya.Method {
    return .get
  }

  var path: String {
    switch self {
    case .list:
      return "/topics"
    case .photos(let parameter):
      return "/topics/\(parameter.idOrSlug)/photos"
    }
  }

  var sampleData: Data {
    return TopicSampleDataFetcher.fetch(target: self)
  }

  var task: Task {
    let parameters: [String: Any] = {
      switch self {
      case .list(let parameter):
        var parameters: [String: Any] = [:]

        if let ids = parameter.ids {
          parameters["ids"] = ids
        }

        if let page = parameter.page {
          parameters["page"] = page
        }

        if let numberOfItems = parameter.numberOfItems {
          parameters["per_page"] = numberOfItems
        }

        if let orderBy = parameter.orderBy {
          parameters["order_by"] = orderBy.rawValue
        }

        return parameters

      case .photos(let parameter):
        var parameters: [String: Any] = ["id_or_slug": parameter.idOrSlug]

        if let page = parameter.page {
          parameters["page"] = page
        }

        if let numberOfItems = parameter.numberOfItems {
          parameters["per_page"] = numberOfItems
        }

        if let orientation = parameter.orientation {
          parameters["orientation"] = orientation.rawValue
        }

        if let orderBy = parameter.orderBy {
          parameters["order_by"] = orderBy.rawValue
        }

        return parameters
      }
    }()

    return .requestParameters(parameters: parameters, encoding: URLEncoding.default)
  }
}
