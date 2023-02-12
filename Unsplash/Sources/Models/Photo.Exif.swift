//
//  Photo.Exif.swift
//  Unsplash
//
//  Created by 안재영 on 2023/01/06.
//

import Photos


extension Photo {

  struct Exif: Decodable {

    // MARK: - Defines

    enum CodingKeys: String, CodingKey {
      case make, model, aperture, iso
      case exposureTime = "exposure_time"
      case focalLength = "focal_length"
    }


    // MARK: - Properties

    var make: String?

    var model: String?

    var exposureTime: String?

    var aperture: String?

    var focalLength: String?

    var iso: String?


    // MARK: - Initializers

    init(
      make: String?,
      model: String?,
      exposureTime: String?,
      aperture: String?,
      focalLength: String?,
      iso: String?
    ) {
      self.make = make
      self.model = model
      self.aperture = aperture
      self.exposureTime = exposureTime
      self.focalLength = focalLength
      self.iso = iso
    }

    init(from decoder: Decoder) throws {
      let container: KeyedDecodingContainer<Photo.Exif.CodingKeys> = try decoder.container(
        keyedBy: Photo.Exif.CodingKeys.self
      )
      self.make = try container.decodeIfPresent(String.self, forKey: .make)
      self.model = try container.decodeIfPresent(String.self, forKey: .model)
      self.aperture = try container.decodeIfPresent(String.self, forKey: .aperture)
      self.exposureTime = try container.decodeIfPresent(String.self, forKey: .exposureTime)
      self.focalLength = try container.decodeIfPresent(String.self, forKey: .focalLength)

      if let iso = try container.decodeIfPresent(Int.self, forKey: .iso) {
        self.iso = String(iso)
      }
    }

    init(dictionary: [CFString: Any]) {
      var make: String?
      var model: String?
      var exposureTime: String?
      var aperture: String?
      var focalLength: String?
      var iso: String?

      if let exifDictionary: [CFString: Any] = dictionary[kCGImagePropertyExifDictionary] as? [CFString: Any] {
        make = exifDictionary[kCGImagePropertyExifLensMake] as? String
        
        if let exposureTimeProperty: Double = exifDictionary[kCGImagePropertyExifExposureTime] as? Double {
          exposureTime = .init(format: "1/%.0f", 1 / exposureTimeProperty)
        }

        if let apertureProperty: Double = exifDictionary[kCGImagePropertyExifApertureValue] as? Double {
          aperture = .init(format: "%.1f", apertureProperty)
        }

        if let focalLengthProperty: Double = exifDictionary[kCGImagePropertyExifFocalLength] as? Double {
          focalLength = .init(format: "%.1f", focalLengthProperty)
        }

        let isoSpeedRatingsProperty: [Int]? = exifDictionary[kCGImagePropertyExifISOSpeedRatings] as? [Int]
        if let isoSpeedRating: Int = isoSpeedRatingsProperty?.first {
          iso = .init(isoSpeedRating)
        }
      }

      if let tiffDictionary: [CFString: Any] = dictionary[kCGImagePropertyTIFFDictionary] as? [CFString: Any] {
        model = tiffDictionary[kCGImagePropertyTIFFModel] as? String
      }

      self.make = make
      self.model = model
      self.exposureTime = exposureTime
      self.aperture = aperture
      self.focalLength = focalLength
      self.iso = iso
    }
  }
}
