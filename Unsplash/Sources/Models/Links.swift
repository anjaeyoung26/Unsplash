//
//  Links.swift
//  Unsplash
//
//  Created by 안재영 on 2022/12/27.
//

struct Links: Decodable {

  // MARK: - Defines

  enum CodingKeys: String, CodingKey {
    case `self`, html, download, photos, related, following, followers, portfolio, likes
    case downloadLocation = "download_location"
  }


  // MARK: - Properties

  var `self`: String?

  var html: String?

  var download: String?

  var downloadLocation: String?

  var photos: String?

  var related: String?

  var following: String?

  var followers: String?

  var portfolio: String?

  var likes: String?
}
