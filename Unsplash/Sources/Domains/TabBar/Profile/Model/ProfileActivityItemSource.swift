//
//  ProfileActivityItemSource.swift
//  Unsplash
//
//  Created by 안재영 on 2023/01/30.
//

import LinkPresentation
import UIKit


final class ProfileActivityItemSource: NSObject, UIActivityItemSource {

  // MARK: - Properties

  var user: User


  // MARK: - Initializers

  init(user: User) {
    self.user = user

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
    if let portfolioURLString: String = self.user.portfolioURL {
      return URL(string: portfolioURLString)
    } else {
      return nil
    }
  }

  func activityViewControllerLinkMetadata(
    _ activityViewController: UIActivityViewController
  ) -> LPLinkMetadata? {
    let metadata: LPLinkMetadata = .init()
    metadata.title = self.user.name
    metadata.originalURL = .init(string: "unsplash.com")

    if let portfolioURLString: String = self.user.portfolioURL {
      metadata.url = .init(string: portfolioURLString)
    }

    DispatchQueue.global().async {
      if let profileURLString: String = self.user.profileImage?.small,
         let profileURL: URL = .init(string: profileURLString),
         let data: Data = try? .init(contentsOf: profileURL) {
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
