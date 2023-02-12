//
//  UserAPI.swift
//  Unsplash
//
//  Created by 안재영 on 2022/12/27.
//

import Foundation
import Moya


enum UserAPI {
  case likePhotos(Parameter.UserLikePhotos)
  case me
  case stat(Parameter.Stat)
  case updateProfile(Parameter.UpdateProfile)
  case userCollections(Parameter.UserCollections)
  case userPhotos(Parameter.UserPhotos)
}


// MARK: - TargetType

extension UserAPI: TargetType {

  var baseURL: URL {
    return .init(string: "https://api.unsplash.com")!
  }

  var headers: [String : String]? {
    return nil
  }

  var method: Moya.Method {
    switch self {
    case .updateProfile:
      return .put
    case .likePhotos, .me, .stat, .userCollections, .userPhotos:
      return .get
    }
  }

  var path: String {
    switch self {
    case .likePhotos(let parameter):
      return "/users/\(parameter.userName)/likes"
    case .me:
      return "/me"
    case .stat(let parameter):
      return "/users/\(parameter.userName)/statistics"
    case .updateProfile:
      return "/me"
    case .userCollections(let parameter):
      return "/users/\(parameter.userName)/collections"
    case .userPhotos(let parameter):
      return "/users/\(parameter.userName)/photos"
    }
  }

  var sampleData: Data {
    return UserSampleDataFetcher.fetch(target: self)
  }

  var task: Task {
    let parameters: [String: Any] = {
      switch self {
      case .likePhotos(let parameter):
        var parameters: [String: Any] = [:]
        
        if let page = parameter.page {
          parameters["page"] = page
        }
        
        if let numberOfItems = parameter.numberOfItems {
          parameters["per_page"] = numberOfItems
        }
        
        if let orderBy = parameter.orderBy {
          parameters["order_by"] = orderBy.rawValue
        }
        
        if let orientation = parameter.orientation {
          parameters["orientation"] = orientation.rawValue
        }
        
        return parameters
        
      case .me:
        return [:]
        
      case .stat(let parameter):
        var parameters: [String: Any] = ["username": parameter.userName]
        
        if let resolution = parameter.resolution {
          parameters["resolution"] = resolution
        }
        
        if let quantity = parameter.quantity {
          parameters["quantity"] = quantity
        }
        
        return parameters
        
      case .updateProfile(let parameter):
        var parameters: [String: Any] = [:]
        
        if let userName = parameter.userName {
          parameters["username"] = userName
        }

        if let firstName = parameter.firstName {
          parameters["first_name"] = firstName
        }

        if let lastName = parameter.lastName {
          parameters["last_name"] = lastName
        }

        if let email = parameter.email {
          parameters["email"] = email
        }

        if let location = parameter.location {
          parameters["location"] = location
        }

        if let url = parameter.url {
          parameters["url"] = url
        }
        
        return parameters
        
      case .userCollections(let parameter):
        var parameters: [String: Any] = ["username": parameter.userName]
        
        if let page = parameter.page {
          parameters["page"] = page
        }
        
        if let numberOfItems = parameter.numberOfItems {
          parameters["per_page"] = numberOfItems
        }
        
        return parameters
        
      case .userPhotos(let parameter):
        var parameters: [String: Any] = [:]
        
        if let page = parameter.page {
          parameters["page"] = page
        }
        
        if let numberOfItems = parameter.numberOfItems {
          parameters["per_page"] = numberOfItems
        }
        
        if let orderBy = parameter.orderBy {
          parameters["order_by"] = orderBy.rawValue
        }
        
        if let stats = parameter.stats {
          parameters["stats"] = stats
        }
        
        if let resolution = parameter.resolution {
          parameters["resolution"] = resolution
        }
        
        if let quantity = parameter.quantity {
          parameters["quantity"] = quantity
        }
        
        if let orientation = parameter.orientation {
          parameters["orientation"] = orientation.rawValue
        }
        
        return parameters
      }
    }()

    return .requestParameters(parameters: parameters, encoding: URLEncoding.default)
  }
}
