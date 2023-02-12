//
//  Photo.swift
//  Unsplash
//
//  Created by 안재영 on 2022/12/27.
//

import Photos


struct Photo: Decodable {

  // MARK: - Defines

  enum Orientation: String {
    case landscape
    case portrait
    case squarish
  }

  enum CodingKeys: String, CodingKey {
    case id,
         width,
         height,
         downloads,
         views,
         likes,
         description,
         sponsorship,
         exif,
         location,
         user,
         urls,
         links,
         tags
    case createdAt = "created_at"
    case publishedAt = "published_at"
    case updatedAt = "updated_at"
    case promotedAt = "promoted_at"
    case colorHexCode = "color"
    case blurHash = "blur_hash"
    case likedByUser = "liked_by_user"
    case altDescription = "alt_description"
    case currentUserCollections = "current_user_collections"
  }


  // MARK: - Properties

  var id: String

  var createdAt: String

  var publishedAt: String?

  var updatedAt: String

  var promotedAt: String?

  var width: Double

  var height: Double

  var colorHexCode: String

  var blurHash: String?

  var downloads: Int?

  var views: Int?

  var likes: Int

  var likedByUser: Bool?

  var altDescription: String?

  var description: String?

  var sponsorship: Sponsorship?

  var exif: Exif?

  var location: Location?

  var user: User

  var currentUserCollections: [Collection]

  var urls: URLs

  var links: Links

  var tags: [Tag]?


  // MARK: - URLs

  struct URLs: Decodable {

    // MARK: - Properties

    var raw: String

    var full: String

    var regular: String

    var small: String

    var thumb: String
  }


  // MARK: - Download

  struct Download: Decodable {

    // MARK: - Properties

    var url: String
  }


  // MARK: - Preview

  struct Preview: Decodable {

    // MARK: - Defines

    enum CodingKeys: String, CodingKey {
      case id, urls
      case blurHash = "blur_hash"
      case createdAt = "created_at"
      case updatedAt = "updated_at"
    }

    
    // MARK: - Properties

    var id: String

    var blurHash: String?

    var createdAt: String

    var updatedAt: String

    var urls: URLs
  }


  // MARK: - Sponsorship

  struct Sponsorship: Decodable {

    // MARK: - Defines

    enum CodingKeys: String, CodingKey {
      case sponsor, tagline
      case taglineURL = "tagline_url"
      case impressionURLs = "impression_urls"
    }

    // MARK: - Properties

    var impressionURLs: [String]?

    var sponsor: User

    var taglineURL: String?

    var tagline: String?
  }


  // MARK: - Tag

  struct Tag: Decodable {

    // MARK: - Defines

    enum TagType: String, Decodable {
      case search
      case landingPage = "landing_page"
    }


    // MARL; - Properties

    var type: TagType

    var title: String
  }
}
