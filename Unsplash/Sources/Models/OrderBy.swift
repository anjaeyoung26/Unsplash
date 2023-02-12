//
//  OrderBy.swift
//  Unsplash
//
//  Created by 안재영 on 2022/12/27.
//

enum OrderBy {

  // MARK: - CollectionPhotos

  enum CollectionPhotos: String {
    case landscape
    case portrait
    case squarish
  }


  // MARK: - Default

  enum Default: String {
    case latest
    case oldest
    case popular
  }


  // MARK: - SearchPhotos

  enum SearchPhotos: String {
    case latest
    case relevant
  }


  // MARK: - UserPhotos

  enum UserPhotos: String {
    case latest
    case oldest
    case popular
    case views
    case downloads
  }


  // MARK: - Topics

  enum Topics: String {
    case featured
    case latest
    case oldest
    case position
  }
}
