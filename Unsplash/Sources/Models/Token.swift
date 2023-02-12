//
//  Token.swift
//  Unsplash
//
//  Created by 안재영 on 2022/12/30.
//

struct Token: Decodable {

  // MARK: - Defines

  enum CodingKeys: String, CodingKey {
    case scope
    case accessToken = "access_token"
    case refreshToken = "refresh_token"
    case type = "token_type"
  }
  

  // MARK: - Properties

  var accessToken: String

  var refreshToken: String

  var scope: String

  var type: String
}
