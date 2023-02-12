//
//  Response.swift
//  Unsplash
//
//  Created by 안재영 on 2022/12/27.
//

enum Response {

  // MARK: - LikePhoto

  struct LikePhoto: Decodable {

    // MARK: - Properties

    var photo: Photo

    var user: User
  }


  // MARK: - SearchPhotos

  struct SearchPhotos: Decodable {

    // MARK: - Defines

    enum CodingKeys: String, CodingKey {
      case total, results
      case totalPages = "total_pages"
    }


    // MARK: - Properties

    var total: Int

    var totalPages: Int

    var results: [Photo]
  }


  // MARK: - SearchCollections

  struct SearchCollections: Decodable {

    // MARK: - Defines

    enum CodingKeys: String, CodingKey {
      case total, results
      case totalPages = "total_pages"
    }


    // MARK: - Properties

    var total: Int

    var totalPages: Int

    var results: [Collection]
  }


  // MARK: - SearchUsers

  struct SearchUsers: Decodable {

    // MARK: - Defines

    enum CodingKeys: String, CodingKey {
      case total, results
      case totalPages = "total_pages"
    }


    // MARK: - Properties

    var total: Int

    var totalPages: Int

    var results: [User]
  }


  // MARK: - UpdateCollection

  struct UpdateCollection: Decodable {

    // MARK: - Defines

    enum CodingKeys: String, CodingKey {
      case collection, photo, user
      case createdAt = "created_at"
    }


    // MARK: - Properties

    var createdAt: String

    var collection: Collection

    var photo: Photo

    var user: User
  }
}
