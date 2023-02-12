//
//  EditLocationViewModel.swift
//  Unsplash
//
//  Created by 안재영 on 2023/01/08.
//

import MapKit
import RxCocoa
import RxSwift


final class EditLocationViewModel: ViewModelType {

  // MARK: - Defines

  struct Inputs {
    let requestLocalSearch: Observable<MKLocalSearchCompletion>
  }

  struct Outputs {
    let location: Driver<Location>
    let presentAlert: Driver<RxAlert<Void>>
  }

  private struct Subject {
    let error: PublishSubject<Error> = .init()
  }


  // MARK: - Properties

  private var localSearch: MKLocalSearch?

  private let disposeBag: DisposeBag = .init()

  private let subject: Subject = .init()


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

    let mapItem: Observable<MKMapItem> = inputs.requestLocalSearch
      .flatMapLatest { [weak self] (
        searchCompletion: MKLocalSearchCompletion
      ) -> Observable<MKLocalSearch.Response> in
        let searchRequest: MKLocalSearch.Request = .init(completion: searchCompletion)
        searchRequest.resultTypes = .pointOfInterest

        self?.localSearch = MKLocalSearch(request: searchRequest)
        return self?.localSearch?.rx
          .start()
          .asObservable()
          .suppressError(observer: errorObserver) ?? .empty()
      }
      .map { (response: MKLocalSearch.Response) -> MKMapItem in return response.mapItems[0] }

    let location: Observable<Location> = mapItem
      .map { (item: MKMapItem) -> Location in
        return .init(
          name: item.name,
          city: item.placemark.locality,
          country: item.placemark.country,
          position: .init(
            latitude: item.placemark.coordinate.latitude,
            longitude: item.placemark.coordinate.longitude
          )
        )
      }

    return .init(
      location: location.asDriver(onErrorDriveWith: .empty()),
      presentAlert: presentAlert.asDriver(onErrorDriveWith: .empty())
    )
  }
}
