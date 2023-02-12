//
//  User.swift
//  Unsplash
//
//  Created by 안재영 on 2022/12/27.
//

import Foundation


final class User: Decodable {

  // MARK: - Defines

  enum CodingKeys: String, CodingKey {
    case id, name, bio, location, links, social, email
    case updatedAt = "updated_at"
    case userName = "username"
    case firstName = "first_name"
    case lastName = "last_name"
    case forHire = "for_hire"
    case portfolioURL = "portfolio_url"
    case totalLikes = "total_likes"
    case totalPhotos = "total_photos"
    case totalCollections = "total_collections"
    case instagramUserName = "instagram_username"
    case twitterUserName = "twitter_username"
    case profileImage = "profile_image"
  }

  
  // MARK: - Properties

  private(set) static var me: User?

  var id: String

  var updatedAt: String?

  var userName: String

  var firstName: String?

  var lastName: String?

  var name: String

  var forHire: Bool?

  var portfolioURL: String?

  var bio: String?

  var location: String?

  var email: String?

  var totalLikes: Int?

  var totalPhotos: Int?

  var totalCollections: Int?

  var instagramUserName: String?

  var twitterUserName: String?

  var profileImage: ProfileImage?

  var social: Social?

  var links: Links


  // MARK: - Methods

  class func update(_ user: User) {
    NotificationCenter.default.post(name: .UpdateUser, object: user)
    User.me = user
  }

  class func delete() {
    NotificationCenter.default.post(name: .DeleteUser, object: nil)
    User.me = nil
  }


  // MARK: - ProfileImage

  struct ProfileImage: Decodable {

    // MARK: - Properties

    var small: String

    var medium: String

    var large: String
  }


  // MARK: - Social

  struct Social: Decodable {

    // MARK: - Defines

    enum CodingKeys: String, CodingKey {
      case instagramUserName = "instagram_username"
      case twitterUserName = "twitter_username"
      case portfolioURL = "portfolio_url"
      case paypalEmail = "paypal_email"
    }


    // MARK: - Properties

    var instagramUserName: String?

    var twitterUserName: String?

    var portfolioURL: String?

    var paypalEmail: String?
  }
}


// MARK: - Equatable

extension User: Equatable {

  static func == (lhs: User, rhs: User) -> Bool {
    return lhs.id == rhs.id
  }
}
