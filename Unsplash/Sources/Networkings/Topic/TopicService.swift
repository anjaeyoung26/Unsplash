//
//  TopicService.swift
//  Unsplash
//
//  Created by 안재영 on 2023/01/02.
//

import Foundation
import Moya
import RxMoya
import RxSwift


protocol TopicServiceType {

  // MARK: - Properties

  var networking: Networking<TopicAPI> { get }


  // MARK: - Methods

  func list(parameter: Parameter.ListTopics) -> Single<List<Topic>>

  func photos(parameter: Parameter.TopicPhotos) -> Single<List<Photo>>
}


// MARK: - TopicService

final class TopicService: TopicServiceType {

  // MARK: - Properties

  var networking: Networking<TopicAPI>


  // MARK: - Initializers

  init(networking: Networking<TopicAPI>) {
    self.networking = networking
  }


  // MARK: - Methods

  func list(parameter: Parameter.ListTopics) -> Single<List<Topic>> {
    return self.networking.rx
      .request(.list(parameter))
      .map(List<Topic>.self)
  }

  func photos(parameter: Parameter.TopicPhotos) -> Single<List<Photo>> {
    return self.networking.rx
      .request(.photos(parameter))
      .map(List<Photo>.self)
  }
}
