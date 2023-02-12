//
//  InfoPhotoSectionItem.swift
//  Unsplash
//
//  Created by 안재영 on 2023/01/15.
//

enum InfoPhotoSectionItem {
  case exifMake(String)
  case exifModel(String)
  case exifFocalLength(String)
  case exifAperture(String)
  case exifShutterSpeed(String)
  case exifISO(String)
  case dimensions(Double, Double)
  case publishedAt(String)
}
