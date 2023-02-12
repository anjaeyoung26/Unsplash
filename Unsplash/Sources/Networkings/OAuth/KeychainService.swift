//
//  KeychainService.swift
//  Unsplash
//
//  Created by 안재영 on 2022/12/30.
//

import KeychainAccess


protocol KeychainServiceType {

  // MARK: - Properties

  var keychain: Keychain { get }


  // MARK: - Methods

  func saveToken(_ token: Token) throws

  func deleteToken() throws

  func fetchToken() -> Token?
}


// MARK: - KeychainService

final class KeychainService: KeychainServiceType {

  // MARK: - Properties

  var keychain: Keychain


  // MARK: - Initializers

  init(keychain: Keychain) {
    self.keychain = keychain
  }


  // MARK: - Methods

  func saveToken(_ token: Token) throws {
    do {
      try self.keychain.set(token.accessToken, key: "access_token")
      try self.keychain.set(token.refreshToken, key: "refresh_token")
      try self.keychain.set(token.scope, key: "token_scope")
      try self.keychain.set(token.type, key: "token_type")
    } catch {
      throw error
    }
  }

  func deleteToken() throws {
    do {
      try self.keychain.remove("access_token")
      try self.keychain.remove("refresh_token")
      try self.keychain.remove("token_scope")
      try self.keychain.remove("token_type")
    } catch {
      throw error
    }
  }

  func fetchToken() -> Token? {
    guard let accessToken = self.keychain["access_token"],
          let refreshToken = self.keychain["refresh_token"],
          let scope = self.keychain["token_scope"],
          let type = self.keychain["token_type"] else { return nil }
    return .init(
      accessToken: accessToken,
      refreshToken: refreshToken,
      scope: scope,
      type: type
    )
  }
}
