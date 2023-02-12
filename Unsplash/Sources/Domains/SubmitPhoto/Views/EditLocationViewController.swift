//
//  EditLocationViewController.swift
//  Unsplash
//
//  Created by 안재영 on 2023/01/07.
//

import MapKit
import RxSwift
import SnapKit
import UIKit


final class EditLocationViewController: BaseViewController {

  // MARK: - Defines

  fileprivate struct Subject {
    let selectedLocation: PublishSubject<Location> = .init()
  }


  // MARK: - UI Components

  private let doneButton: UIButton = {
    let button: UIButton = .init()
    button.titleLabel?.font = .systemFont(ofSize: 17)
    button.setTitle("Done", for: .normal)
    button.setTitleColor(.white, for: .normal)
    return button
  }()

  private let mapView: MKMapView = {
    let view: MKMapView = .init()
    return view
  }()

  private let blurView: UIVisualEffectView = {
    let blurEffect: UIBlurEffect = .init(style: .dark)
    let view: UIVisualEffectView = .init(effect: blurEffect)
    view.isHidden = true
    return view
  }()


  // MARK: - Properties

  private let locationResultTableViewController: LocationResultTableViewController = {
    let viewController: LocationResultTableViewController = .init()
    viewController.view.backgroundColor = .clear
    return viewController
  }()

  private let searchCompleter: MKLocalSearchCompleter = {
    let completer: MKLocalSearchCompleter = .init()
    completer.resultTypes = .pointOfInterest
    return completer
  }()

  fileprivate let subject: Subject = .init()

  private var searchController: UISearchController?

  private let viewModel: EditLocationViewModel

  private let priorLocation: Location?


  // MARK: - Initializers

  init(viewModel: EditLocationViewModel, priorLocation: Location?) {
    self.viewModel = viewModel
    self.priorLocation = priorLocation

    super.init()
  }

  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }


  // MARK: - Life Cycle

  override func viewDidLoad() {
    super.viewDidLoad()

    self.setupSearchController()
    self.setAnnotationIfPriorLocationExist()
    self.searchCompleter.delegate = self
  }

  override func viewDidAppear(_ animated: Bool) {
    super.viewDidAppear(animated)

    DispatchQueue.main.async {
      self.searchController?.searchBar.becomeFirstResponder()
    }
  }


  // MARK: - Layout

  override func addSubviews() {
    super.addSubviews()

    self.view.add(
      self.mapView,
      self.blurView
    )
  }

  override func setConstraints() {
    super.setConstraints()

    self.mapView.snp.makeConstraints { (make: ConstraintMaker) in
      make.edges.equalToSuperview()
    }

    self.blurView.snp.makeConstraints { (make: ConstraintMaker) in
      make.edges.equalToSuperview()
    }
  }

  override func setNavigationBar() {
    super.setNavigationBar()

    self.navigationItem.setTitleView(title: "Edit Location")
    self.navigationItem.rightBarButtonItem = .init(customView: self.doneButton)

    let appearance: UINavigationBarAppearance = .init()
    appearance.configureWithTransparentBackground()
    self.navigationController?.navigationBar.standardAppearance = appearance
  }

  private func setupSearchController() {
    self.searchController = .init(searchResultsController: self.locationResultTableViewController)
    self.searchController?.delegate = self
    self.searchController?.searchBar.delegate = self
    self.searchController?.searchResultsUpdater = self
    self.navigationItem.searchController = self.searchController
  }


  // MARK: - Bind

  override func bind() {
    super.bind()

    let outputs: EditLocationViewModel.Outputs = self.viewModel.transform(inputs: .init(
      requestLocalSearch: self.locationResultTableViewController.rx.didSelectSearchCompletion
    ))

    outputs.location
      .drive(self.subject.selectedLocation)
      .disposed(by: self.disposeBag)

    outputs.presentAlert
      .drive(self.rx.presentAlert)
      .disposed(by: self.disposeBag)

    self.doneButton.rx
      .tap
      .throttle(.milliseconds(250), scheduler: MainScheduler.instance)
      .subscribe(onNext: { [weak self] in self?.dismiss(animated: true) })
      .disposed(by: self.disposeBag)
  }


  // MARK: - Methods (Private)

  private func setAnnotationIfPriorLocationExist() {
    if let priorLocation = self.priorLocation,
       let latitude: Double = priorLocation.position.latitude,
       let longitude: Double = priorLocation.position.longitude {
      let center: CLLocationCoordinate2D = .init(latitude: latitude, longitude: longitude)
      let span: MKCoordinateSpan = .init(latitudeDelta: 0.005, longitudeDelta: 0.005)
      self.mapView.region = .init(center: center, span: span)

      let annotation: MKPointAnnotation = .init()
      annotation.title = priorLocation.name
      annotation.coordinate = center
      self.mapView.addAnnotation(annotation)
    }
  }
}


// MARK: - UISearchBarDelegate

extension EditLocationViewController: UISearchBarDelegate {

  func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
    searchBar.resignFirstResponder()
  }

  func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
    searchBar.resignFirstResponder()
  }
}


// MARK: - UISearchControllerDelegate

extension EditLocationViewController: UISearchControllerDelegate {

  func presentSearchController(_ searchController: UISearchController) {
    self.blurView.isHidden = false
  }

  func willDismissSearchController(_ searchController: UISearchController) {
    self.blurView.isHidden = true
  }
}


// MARK: - MKLocalSearchCompleterDelegate

extension EditLocationViewController: MKLocalSearchCompleterDelegate {

  func completerDidUpdateResults(_ completer: MKLocalSearchCompleter) {
    if !completer.results.isEmpty {
      self.locationResultTableViewController.searchCompletions = completer.results
    }
  }
}


// MARK: - UISearchResultsUpdating

extension EditLocationViewController: UISearchResultsUpdating {

  func updateSearchResults(for searchController: UISearchController) {
    self.searchCompleter.queryFragment = searchController.searchBar.text ?? ""
  }
}


// MARK: - Reactive

extension Reactive where Base: EditLocationViewController {

  var didSelectLocation: Observable<Location> {
    return base.subject
      .selectedLocation
      .asObservable()
  }
}
