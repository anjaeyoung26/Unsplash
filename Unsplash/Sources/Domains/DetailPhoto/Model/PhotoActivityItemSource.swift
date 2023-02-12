//
//  PhotoActivityItemSource.swift
//  Unsplash
//
//  Created by 안재영 on 2023/01/17.
//

import LinkPresentation
import UIKit


final class PhotoActivityItemSource: NSObject, UIActivityItemSource {

  // MARK: - Properties

  var photo: Photo


  // MARK: - Initializers

  init(photo: Photo) {
    self.photo = photo

    super.init()
  }


  // MARK: - UIActivityItemSource

  func activityViewControllerPlaceholderItem(
    _ activityViewController: UIActivityViewController
  ) -> Any {
    return ""
  }

  func activityViewController(
    _ activityViewController: UIActivityViewController,
    itemForActivityType activityType: UIActivity.ActivityType?
  ) -> Any? {
    return URL(string: self.photo.urls.raw)
  }

  func activityViewControllerLinkMetadata(
    _ activityViewController: UIActivityViewController
  ) -> LPLinkMetadata? {
    let metadata: LPLinkMetadata = .init()
    metadata.url = URL(string: self.photo.urls.raw)
    metadata.title = "Photo by \(self.photo.user.userName)"
    metadata.originalURL = URL(string: "unsplash.com")

    DispatchQueue.global().async {
      if let url: URL = .init(string: self.photo.urls.thumb),
         let data: Data = try? .init(contentsOf: url) {
        DispatchQueue.main.async {
          if let image: UIImage = .init(data: data) {
            metadata.iconProvider = NSItemProvider(object: image)
          }
        }
      }
    }

    return metadata
  }
}
