//
//  Location.swift
//  Unsplash
//
//  Created by 안재영 on 2022/12/27.
//

struct Location: Decodable {

  // MARK: - Properties

  var name: String?

  var city: String?

  var country: String?

  var position: Position


  // MARK: - Position

  struct Position: Decodable {

    // MARK: - Properties

    var latitude: Double?

    var longitude: Double?
  }
}
