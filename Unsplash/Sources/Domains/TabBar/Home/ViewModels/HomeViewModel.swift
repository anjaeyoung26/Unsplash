//
//  HomeViewModel.swift
//  Unsplash
//
//  Created by 안재영 on 2022/12/28.
//

import RxCocoa
import RxSwift


final class HomeViewModel: ViewModelType {

  // MARK: - Defines

  struct Inputs {
    let requestTopics: Observable<Void>
  }

  struct Outputs {
    let pagingDataSource: Driver<TopicPagingDataSource>
    let presentAlert: Driver<RxAlert<Void>>
    let presentOnboarding: Driver<Void>
  }

  private struct Subject {
    let error: PublishSubject<Error> = .init()
  }


  // MARK: - Properties

  private let disposeBag: DisposeBag = .init()

  private let subject: Subject = .init()

  private let topicService: TopicServiceType


  // MARK: - Initializers

  init(topicService: TopicServiceType) {
    self.topicService = topicService
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

    let presentOnboarding: Observable<Void> = inputs.requestTopics
      .map { _ -> Bool in Setting.didTapStartBrowsingInOnboarding }
      .filter { (didTapStartBrowsingInOnboarding: Bool) -> Bool in
        return !didTapStartBrowsingInOnboarding
      }
      .map { _ in }

    let topics: Observable<[Topic]> = inputs.requestTopics
      .flatMapLatest { [weak self] _ -> Observable<List<Topic>> in
        return self?.topicService
          .list(parameter: .init(numberOfItems: 20))
          .asObservable()
          .suppressError(observer: errorObserver) ?? .empty()
      }
      .map { (list: List<Topic>) -> [Topic] in list.items }

    let pagingDataSource: Observable<TopicPagingDataSource> = topics
      .map { (topics: [Topic]) -> TopicPagingDataSource in
        return .init(
          topicViewControllers: topics.map { (topic: Topic) -> TopicViewController in
            return AppAssembler.resolve(TopicViewController.self, argument: topic)
          },
          topics: topics
        )
      }

    return .init(
      pagingDataSource: pagingDataSource.asDriver(onErrorDriveWith: .empty()),
      presentAlert: presentAlert.asDriver(onErrorDriveWith: .empty()),
      presentOnboarding: presentOnboarding.asDriver(onErrorDriveWith: .empty())
    )
  }
}
