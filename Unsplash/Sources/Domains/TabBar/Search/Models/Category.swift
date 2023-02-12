//
//  Category.swift
//  Unsplash
//
//  Created by 안재영 on 2023/01/19.
//

import UIKit


enum Category: CaseIterable {
  case abstract
  case animals
  case blackAndWhite
  case flowers
  case gradients
  case minimal
  case nature
  case sky
  case space
  case travel
  case underwater

  // MARK: - Properties

  var image: UIImage? {
    switch self {
    case .abstract:
      return .init(named: "cover_abstract.jpg")
    case .animals:
      return .init(named: "cover_animals.jpg")
    case .blackAndWhite:
      return .init(named: "cover_black_and_white.jpg")
    case .flowers:
      return .init(named: "cover_flowers.jpg")
    case .gradients:
      return .init(named: "cover_gradients.jpg")
    case .minimal:
      return .init(named: "cover_minimal.jpg")
    case .nature:
      return .init(named: "cover_nature.jpg")
    case .sky:
      return .init(named: "cover_sky.jpg")
    case .space:
      return .init(named: "cover_space.jpg")
    case .travel:
      return .init(named: "cover_travel.jpg")
    case .underwater:
      return .init(named: "cover_underwater.jpg")
    }
  }

  var title: String {
    switch self {
    case .abstract:
      return "Abstract"
    case .animals:
      return "Animals"
    case .blackAndWhite:
      return "Black and White"
    case .flowers:
      return "Flowers"
    case .gradients:
      return "Gradients"
    case .minimal:
      return "Minimal"
    case .nature:
      return "Nature"
    case .sky:
      return "Sky"
    case .space:
      return "Space"
    case .travel:
      return "Travel"
    case .underwater:
      return "Underwater"
    }
  }
}
