//
//  AppMenuViewModel.swift
//  Unsplash
//
//  Created by 안재영 on 2023/01/01.
//

import Foundation
import MessageUI
import RxCocoa
import RxSwift


final class AppMenuViewModel: ViewModelType {

  // MARK: - Defines

  struct Inputs {
    let loadSections: Observable<Void>
  }

  struct Outputs {
    let sections: Driver<[AppMenuSection]>
  }


  // MARK: - Properties

  private let disposeBag: DisposeBag = .init()


  // MARK: - Transform

  func transform(inputs: Inputs) -> Outputs {
    let version = Bundle.main.object(
      forInfoDictionaryKey: "CFBundleShortVersionString"
    ) as? String ?? ""

    let sections: Observable<[AppMenuSection]> = inputs.loadSections
      .map { _ -> [AppMenuSection] in
        var sections: [AppMenuSection] = [
          .init(items: [
            .summary(.init(
              name: "Unsplash",
              icon: .init(named: "navigation_icon"),
              version: version
            ))
          ]),
          .init(items: [
            .recommend(items: [UIImage(named: "recommend_icon")]),
            .review(url: .init(string: "https://itunes.apple.com/app/id\(1290631746)?action=write-review")!)
          ]),
          .init(items: [
            .visit(url: .init(string: "https://unsplash.com")!),
            .license(url: .init(string: "https://unsplash.com/license")!)
          ])
        ]

        if MFMailComposeViewController.canSendMail() {
          sections[1].items.append(
            .feedback(.init(
              recipients: ["apps@unsplash.com"],
              subject: "Unsplash for iOS v\(version) Feedback"
            ))
          )
        }

        return sections
      }

    return .init(sections: sections.asDriver(onErrorDriveWith: .empty()))
  }
}
