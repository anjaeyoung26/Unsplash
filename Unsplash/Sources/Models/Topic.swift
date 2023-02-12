//
//  Topic.swift
//  Unsplash
//
//  Created by 안재영 on 2023/01/01.
//

struct Topic: Decodable {

  // MARK: - Defines

  enum CodingKeys: String, CodingKey {
    case id, slug, title, description, featured, links, status, owners
    case publishedAt = "published_at"
    case updatedAt = "updated_at"
    case startsAt = "starts_at"
    case endsAt = "ends_at"
    case totalPhotos = "total_photos"
    case coverPhoto = "cover_photo"
    case previewPhotos = "preview_photos"
  }


  // MARK: - Properties

  var id: String

  var slug: String?

  var title: String

  var description: String

  var publishedAt: String

  var updatedAt: String

  var startsAt: String

  var endsAt: String?

  var featured: Bool

  var totalPhotos: Int

  var links: Links?

  var status: Status

  var owners: [User]

  var coverPhoto: Photo

  var previewPhotos: [Photo.Preview]


  // MARK: - Status

  enum Status: String, Decodable {
    case approved
    case open
    case rejected
    case unevaluated
  }
}
