//
//  PhotoAPI.swift
//  Unsplash
//
//  Created by 안재영 on 2022/12/27.
//

import Foundation
import Moya


enum PhotoAPI {
  case downloadURL(id: String)
  case like(id: String)
  case list(Parameter.ListPhotos)
  case random(Parameter.RandomPhotos)
  case searchCollections(Parameter.SearchCollections)
  case searchPhotos(Parameter.SearchPhotos)
  case searchUsers(Parameter.SearchUsers)
  case single(id: String)
  case unlike(id: String)
  case upload(Parameter.UploadPhoto)
  case url(URL)
}


// MARK: - TargetType

extension PhotoAPI: TargetType {

  var baseURL: URL {
    switch self {
    case .url(let url):
      return url
    case .downloadURL,
         .like,
         .list,
         .random,
         .searchCollections,
         .searchPhotos,
         .searchUsers,
         .single,
         .unlike,
         .upload:
      return .init(string: "https://api.unsplash.com")!
    }
  }

  var headers: [String : String]? {
    return nil
  }

  var method: Moya.Method {
    switch self {
    case .downloadURL,
         .list,
         .random,
         .searchCollections,
         .searchPhotos,
         .searchUsers,
         .single,
         .url:
      return .get
    case .like, .upload:
      return .post
    case .unlike:
      return .delete
    }
  }

  var path: String {
    switch self {
    case .downloadURL(let id):
      return "/photos/\(id)/download"
    case .like(let id):
      return "/photos/\(id)/like"
    case .list:
      return "/photos"
    case .random:
      return "/photos/random"
    case .searchCollections:
      return "/search/collections"
    case .searchPhotos:
      return "/search/photos"
    case .searchUsers:
      return "/search/users"
    case .single(let id):
      return "/photos/\(id)"
    case .unlike(let id):
      return "/photos/\(id)/like"
    case .upload:
      return "/photos"
    case .url:
      return ""
    }
  }

  var sampleData: Data {
    return PhotoSampleDataFetcher.fetch(target: self)
  }

  var task: Task {
    let parameters: [String: Any] = {
      switch self {
      case .list(let parameter):
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

        return parameters

      case .random(let parameter):
        var parameters: [String: Any] = ["count": parameter.count]

        if let collections = parameter.collections {
          parameters["collections"] = collections
        }

        if let topics = parameter.topics {
          parameters["topics"] = topics
        }

        if let userName = parameter.userName {
          parameters["username"] = userName
        }

        if let query = parameter.query {
          parameters["query"] = query
        }

        if let orientation = parameter.orientation {
          parameters["orientation"] = orientation.rawValue
        }

        if let contentFilter = parameter.contentFilter {
          parameters["content_filter"] = contentFilter.rawValue
        }

        return parameters

      case .searchCollections(let parameter):
        var parameters: [String: Any] = ["query": parameter.query]

        if let page = parameter.page {
          parameters["page"] = page
        }

        if let numberOfItems = parameter.numberOfItems {
          parameters["per_page"] = numberOfItems
        }

        return parameters

      case .searchPhotos(let parameter):
        var parameters: [String: Any] = ["query": parameter.query]

        if let page = parameter.page {
          parameters["page"] = page
        }

        if let numberOfItems = parameter.numberOfItems {
          parameters["per_page"] = numberOfItems
        }

        if let orderBy = parameter.orderBy {
          parameters["order_by"] = orderBy.rawValue
        }

        if let collections = parameter.collections {
          parameters["collections"] = collections
        }

        if let contentFilter = parameter.contentFilter {
          parameters["content_filter"] = contentFilter.rawValue
        }

        if let color = parameter.colorFilter {
          parameters["color"] = color.rawValue
        }

        if let orientation = parameter.orientation {
          parameters["orientation"] = orientation.rawValue
        }

        return parameters

      case .searchUsers(let parameter):
        var parameters: [String: Any] = ["query": parameter.query]

        if let page = parameter.page {
          parameters["page"] = page
        }

        if let numberOfItems = parameter.numberOfItems {
          parameters["per_page"] = numberOfItems
        }

        return parameters

      case .upload(let parameter):
        var parameters: [String: Any] = [:]

        if let description = parameter.description {
          parameters["description"] = description
        }

        if let showOnProfile = parameter.showOnProfile {
          parameters["show_on_profile"] = showOnProfile
        }

        if let tags = parameter.tags {
          parameters["tags"] = tags
        }

        if let location = parameter.location {
          if let latitude = location.position.latitude {
            parameters["location[latitude]"] = latitude
          }

          if let longitude = location.position.longitude {
            parameters["longitude"] = longitude
          }

          if let city = location.city {
            parameters["city"] = city
          }

          if let country = location.country {
            parameters["country"] = country
          }
        }

        if let exif = parameter.exif {
          if let make = exif.make {
            parameters["exif[make]"] = make
          }

          if let model = exif.model {
            parameters["exif[model]"] = model
          }

          if let exposureTime = exif.exposureTime {
            parameters["exif[exposure_time]"] = exposureTime
          }

          if let aperture = exif.aperture {
            parameters["exif[aperture_value]"] = aperture
          }

          if let focalLength = exif.focalLength {
            parameters["focal_length"] = focalLength
          }

          if let iso = exif.iso {
            parameters["iso_speed_ratings"] = iso
          }
        }

        return parameters

      case .downloadURL, .like, .single, .unlike, .url:
        return [:]
      }
    }()

    return .requestParameters(parameters: parameters, encoding: URLEncoding.default)
  }
}
