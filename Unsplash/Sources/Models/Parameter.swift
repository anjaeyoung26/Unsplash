//
//  Parameter.swift
//  Unsplash
//
//  Created by 안재영 on 2022/12/27.
//

enum Parameter {

  // MARK: - CollectinoPhotos

  struct CollectionPhotos {

    // MARK: - Properties

    var id: String

    var page: Int?

    var numberOfItems: Int?

    var orientation: Photo.Orientation?
  }


  // MARK: - CreateCollection

  struct CreateCollection {

    // MARK: - Properties

    var description: String?

    var isPrivate: Bool?

    var title: String
  }


  // MARK: - ListPhotos

  struct ListPhotos {

    // MARK: - Properties

    var page: Int?

    var numberOfItems: Int?

    var orderBy: OrderBy.Default?
  }


  // MARK: - RandomPhotos

  struct RandomPhotos {

    // MARK: - Properties

    var collections: [Int]?

    var topics: [Int]?

    var userName: String?

    var query: String?

    var orientation: Photo.Orientation?

    var contentFilter: ContentFilter?

    var count: Int = 1
  }


  // MARK: - UserCollections

  struct UserCollections {

    // MARK: - Properties

    var userName: String

    var page: Int?

    var numberOfItems: Int?
  }


  // MARK: - UserLikePhotos

  struct UserLikePhotos {

    // MARK: - Properties

    var userName: String

    var page: Int?

    var numberOfItems: Int?

    var orderBy: OrderBy.Default?

    var orientation: Photo.Orientation?
  }


  // MARK: - UserPhotos

  struct UserPhotos {

    // MARK: - Properties

    var userName: String

    var page: Int?

    var numberOfItems: Int?

    var orderBy: OrderBy.UserPhotos?

    var stats: Bool?

    var resolution: String?

    var quantity: Int?

    var orientation: Photo.Orientation?
  }


  // MARK: - SearchPhotos

  struct SearchPhotos {

    // MARK: - Properties

    var query: String

    var page: Int?

    var numberOfItems: Int?

    var orderBy: OrderBy.SearchPhotos?

    var collections: [Int]?

    var contentFilter: ContentFilter?

    var colorFilter: ColorFilter?

    var orientation: Photo.Orientation?
  }


  // MARK: - UploadPhoto

  struct UploadPhoto {

    // MARK: - Properties

    var description: String?

    var showOnProfile: Bool?

    var tags: [String]?

    var location: Location?

    var exif: Photo.Exif?
  }


  // MARK: - Authorize

  struct Authorize {

    // MARK: - Properties

    var clientID: String

    var redirectURI: String

    var responseType: String

    var scope: String
  }


  // MARK: - Token

  struct Token {

    // MARK: - Properties

    var clientID: String

    var clientSecret: String

    var code: String

    var grantType: String

    var redirectURI: String
  }


  // MARK: - ListTopics

  struct ListTopics {

    // MARK: - Properties

    var ids: [String]?

    var page: Int?

    var numberOfItems: Int?

    var orderBy: OrderBy.Topics?
  }


  // MARK: - TopicPhotos

  struct TopicPhotos {

    // MARK: - Properties

    var idOrSlug: String

    var page: Int?

    var numberOfItems: Int?

    var orientation: Photo.Orientation?

    var orderBy: OrderBy.Default?
  }


  // MARK: - SearchCollections

  struct SearchCollections {

    // MARK: - Properties

    var query: String

    var page: Int?

    var numberOfItems: Int?
  }


  // MARK: - SearchUsers

  struct SearchUsers {

    // MARK: - Properties

    var query: String

    var page: Int?

    var numberOfItems: Int?
  }


  // MARK: - Stat

  struct Stat {

    // MARK: - Properties

    var userName: String

    var resolution: String?

    var quantity: Int?
  }


  // MARK: - UpdateCollection

  struct UpdateCollection {

    // MARK: - Properties

    var id: String

    var description: String?

    var isPrivate: Bool?

    var title: String?
  }


  // MARK: - UpdateProfile

  struct UpdateProfile {

    // MARK: - Properties

    var userName: String?

    var firstName: String?

    var lastName: String?

    var email: String?

    var location: String?

    var url: String?
  }


  // MARK: - UpdatePhotoToCollection

  struct UpdatePhotoToCollection {

    // MARK: - Properties

    var collectionID: String

    var photoID: String
  }
}
