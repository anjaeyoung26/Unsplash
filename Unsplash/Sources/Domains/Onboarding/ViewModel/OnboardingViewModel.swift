//
//  OnboardingViewModel.swift
//  Unsplash
//
//  Created by 안재영 on 2022/12/28.
//

import Foundation
import RxCocoa
import RxSwift


final class OnboardingViewModel: ViewModelType {

  // MARK: - Defines

  struct Inputs {
    let requestComplete: Observable<Void>
    let loadPhotos: Observable<Int>
  }

  struct Outputs {
    let dismiss: Driver<Void>
    let presentAlert: Driver<RxAlert<Void>>
    let sections: Driver<[PhotoSection]>
  }

  private struct Subject {
    let error: PublishSubject<Error> = .init()
  }


  // MARK: - Properties

  private let disposeBag: DisposeBag = .init()

  private let subject: Subject = .init()

  private let photoService: PhotoServiceType


  // MARK: - Initializers

  init(photoService: PhotoServiceType) {
    self.photoService = photoService
  }


  // MARK: - Transform

  func transform(inputs: Inputs) -> Outputs {
    let errorObserver: PublishSubject<Error> = self.subject.error.asObserver()

    let presentAlert: Observable<RxAlert<Void>> = errorObserver
      .flatMapLatest { (error: Error) -> Observable<RxAlert<Void>> in
        return .just(.init(
          actions: [.init(style: .cancel, title: "OK", value: ())],
          message: error.localizedDescription,
          title: nil
        ))
      }

    let dismiss: Observable<Void> = inputs.requestComplete
      .map { _ in
        #if DEBUG
        Setting.didTapStartBrowsingInOnboarding = false
        #else
        Setting.didTapStartBrowsingInOnboarding = true
        #endif
      }

    let sections: Observable<[PhotoSection]> = inputs.loadPhotos
      .flatMapLatest { [weak self] (count: Int) -> Observable<[Photo]> in
        return self?.photoService
          .random(parameter: .init(count: count))
          .asObservable()
          .suppressError(observer: errorObserver) ?? .empty()
      }
      .map { (photos: [Photo]) -> [PhotoSection] in return [.init(items: photos)] }

    return .init(
      dismiss: dismiss.asDriver(onErrorDriveWith: .empty()),
      presentAlert: presentAlert.asDriver(onErrorDriveWith: .empty()),
      sections: sections.asDriver(onErrorDriveWith: .empty())
    )
  }
}
