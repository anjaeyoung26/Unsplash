//
//  UserService.swift
//  Unsplash
//
//  Created by 안재영 on 2022/12/28.
//

import Foundation
import RxMoya
import RxSwift


protocol UserServiceType {

  // MARK: - Properties

  var networking: Networking<UserAPI> { get }

  
  // MARK: - Methods

  func likePhotos(parameter: Parameter.UserLikePhotos) -> Single<List<Photo>>

  func me() -> Single<User>

  func stat(parameter: Parameter.Stat) -> Single<Stat>

  func updateProfile(parameter: Parameter.UpdateProfile) -> Single<User>

  func userCollections(parameter: Parameter.UserCollections) -> Single<List<Collection>>

  func userPhotos(parameter: Parameter.UserPhotos) -> Single<[Photo]>
}


// MARK: - UserService

final class UserService: UserServiceType {

  // MARK: - Properties

  var networking: Networking<UserAPI>


  // MARK: - Initializers

  init(networking: Networking<UserAPI>) {
    self.networking = networking
  }


  // MARK: - Methods

  func likePhotos(parameter: Parameter.UserLikePhotos) -> Single<List<Photo>> {
    return self.networking.rx
      .request(.likePhotos(parameter))
      .map(List<Photo>.self)
  }

  func me() -> Single<User> {
    return self.networking.rx
      .request(.me)
      .map(User.self)
  }

  func stat(parameter: Parameter.Stat) -> Single<Stat> {
    return self.networking.rx
      .request(.stat(parameter))
      .map(Stat.self)
  }

  func updateProfile(parameter: Parameter.UpdateProfile) -> Single<User> {
    return self.networking.rx
      .request(.updateProfile(parameter))
      .map(User.self)
  }

  func userCollections(parameter: Parameter.UserCollections) -> Single<List<Collection>> {
    return self.networking.rx
      .request(.userCollections(parameter))
      .map(List<Collection>.self)
  }

  func userPhotos(parameter: Parameter.UserPhotos) -> Single<[Photo]> {
    return self.networking.rx
      .request(.userPhotos(parameter))
      .map([Photo].self)
  }
}
