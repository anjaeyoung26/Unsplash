//
//  Collection.swift
//  Unsplash
//
//  Created by 안재영 on 2022/12/27.
//

struct Collection: Decodable {

  // MARK: - Defines

  enum CodingKeys: String, CodingKey {
    case id, title, description, links, user
    case publishedAt = "published_at"
    case lastCollectedAt = "last_collected_at"
    case updatedAt = "updated_at"
    case isPrivate = "private"
    case coverPhoto = "cover_photo"
    case totalPhotos = "total_photos"
  }


  // MARK: - Properties

  var id: String

  var title: String

  var description: String?

  var publishedAt: String

  var lastCollectedAt: String?

  var updatedAt: String

  var isPrivate: Bool?

  var coverPhoto: Photo?

  var totalPhotos: Int?

  var links: Links?

  var user: User?
}


// MARK: - Equatable

extension Collection: Equatable {

  static func == (lhs: Collection, rhs: Collection) -> Bool {
    return lhs.id == rhs.id
  }
}
