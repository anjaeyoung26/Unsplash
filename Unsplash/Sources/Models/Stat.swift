//
//  Stat.swift
//  Unsplash
//
//  Created by 안재영 on 2023/01/31.
//

struct Stat: Decodable {

  // MARK: - Defines

  enum CodingKeys: String, CodingKey {
    case id
    case downloadStat = "downloads"
    case userName = "username"
    case viewStat = "views"
  }


  // MARK: - Properties

  var userName: String

  var id: String

  var downloadStat: DownloadStat

  var viewStat: ViewStat
}


// MARK: - DownloadStat

struct DownloadStat: Decodable {

  // MARK: - Properties

  var total: Int

  var historical: StatHistorical
}


// MARK: - ViewStat

struct ViewStat: Decodable {

  // MARK: - Properties

  var total: Int

  var historical: StatHistorical
}


// MARK: - StatHistorical

struct StatHistorical: Decodable {

  // MARK: - Properties

  var change: Int

  var average: Int

  var resolution: String

  var quantity: Int

  var values: [StatHistoricalValue]
}


// MARK: - StatHistoricalValue

struct StatHistoricalValue: Decodable {

  // MARK: - Properties

  var date: String

  var value: Int
}


// MARK: - StatType

enum StatType {
  case downloads
  case views
}
