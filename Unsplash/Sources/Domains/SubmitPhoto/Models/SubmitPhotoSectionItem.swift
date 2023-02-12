//
//  SubmitPhotoSectionItem.swift
//  Unsplash
//
//  Created by 안재영 on 2023/01/05.
//

enum SubmitPhotoSectionItem {
  case description
  case location
  case tags
  case exifMake(String)
  case exifModel(String)
  case exifFocalLength(String)
  case exifAperture(String)
  case exifShutterSpeed(String)
  case exifISO(String)
  case showOnProfile
}
