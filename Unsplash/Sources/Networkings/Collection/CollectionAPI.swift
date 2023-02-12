//
//  CollectionAPI.swift
//  Unsplash
//
//  Created by 안재영 on 2023/02/07.
//

import Foundation
import Moya


enum CollectionAPI {
  case addPhoto(Parameter.UpdatePhotoToCollection)
  case collectionPhotos(Parameter.CollectionPhotos)
  case createCollection(Parameter.CreateCollection)
  case deleteCollection(id: String)
  case removePhoto(Parameter.UpdatePhotoToCollection)
  case updateCollection(Parameter.UpdateCollection)
}


// MARK: - TargetType

extension CollectionAPI: TargetType {

  var baseURL: URL {
    return .init(string: "https://api.unsplash.com")!
  }

  var headers: [String : String]? {
    return nil
  }

  var method: Moya.Method {
    switch self {
    case .addPhoto:
      return .post
    case .collectionPhotos:
      return .get
    case .createCollection:
      return .post
    case .deleteCollection:
      return .delete
    case .removePhoto:
      return .delete
    case .updateCollection:
      return .put
    }
  }

  var path: String {
    switch self {
    case .addPhoto(let parameter):
      return "/collections/\(parameter.collectionID)/add"
    case .collectionPhotos(let parameter):
      return "/collections/\(parameter.id)/photos"
    case .createCollection:
      return "/collections"
    case .deleteCollection(let id):
      return "/collections/\(id)"
    case .removePhoto(let parameter):
      return "/collections/\(parameter.collectionID)/remove"
    case .updateCollection(let parameter):
      return "/collections/\(parameter.id)"
    }
  }

  var sampleData: Data {
    return CollectionSampleDataFetcher.fetch(target: self)
  }

  var task: Task {
    let parameters: [String: Any] = {
      switch self {
      case .addPhoto(let parameter):
        return [
          "collection_id": parameter.collectionID,
          "photo_id": parameter.photoID
        ]

      case .collectionPhotos(let parameter):
        var parameters: [String: Any] = ["id": parameter.id]

        if let page = parameter.page {
          parameters["page"] = page
        }

        if let numberOfItems = parameter.numberOfItems {
          parameters["per_page"] = numberOfItems
        }

        if let orientation = parameter.orientation {
          parameters["orientation"] = orientation.rawValue
        }

        return parameters

      case .createCollection(let parameter):
        var parameters: [String: Any] = ["title": parameter.title]

        if let description = parameter.description {
          parameters["description"] = description
        }

        if let isPrivate = parameter.isPrivate {
          parameters["private"] = isPrivate
        }

        return parameters

      case .deleteCollection:
        return [:]

      case .removePhoto(let parameter):
        return [
          "collection_id": parameter.collectionID,
          "photo_id": parameter.photoID
        ]

      case .updateCollection(let parameter):
        var parameters: [String: Any] = [:]

        if let title = parameter.title {
          parameters["title"] = title
        }

        if let description = parameter.description {
          parameters["description"] = description
        }

        if let isPrivate = parameter.isPrivate {
          parameters["private"] = isPrivate
        }

        return parameters
      }
    }()

    return .requestParameters(parameters: parameters, encoding: URLEncoding.default)
  }
}
