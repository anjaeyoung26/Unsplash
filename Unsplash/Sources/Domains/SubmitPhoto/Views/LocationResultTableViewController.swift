//
//  LocationResultTableViewController.swift
//  Unsplash
//
//  Created by 안재영 on 2023/01/08.
//

import MapKit
import RxCocoa
import RxSwift
import UIKit


final class LocationResultTableViewController: UITableViewController {

  // MARK: - Properties

  var searchCompletions: [MKLocalSearchCompletion] = [] {
    didSet { self.tableView.reloadData() }
  }


  // MARK: - UITableViewDataSources

  override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return self.searchCompletions.count
  }

  override func tableView(
    _ tableView: UITableView,
    cellForRowAt indexPath: IndexPath
  ) -> UITableViewCell {
    let searchCompletion: MKLocalSearchCompletion = self.searchCompletions[indexPath.row]

    var contentConfiguration: UIListContentConfiguration = .subtitleCell()
    contentConfiguration.text = searchCompletion.title
    contentConfiguration.secondaryText = searchCompletion.subtitle
    contentConfiguration.textProperties.font = .systemFont(ofSize: 16)
    contentConfiguration.secondaryTextProperties.font = .systemFont(ofSize: 13)
    contentConfiguration.textToSecondaryTextVerticalPadding = 5

    var backgroundConfiguration: UIBackgroundConfiguration = .listPlainCell()
    backgroundConfiguration.backgroundColor = .init(
      red: 28/255,
      green: 28/255,
      blue: 30/255,
      alpha: 1.0
    )

    let cell: BaseTableViewCell = .init()
    cell.contentConfiguration = contentConfiguration
    cell.backgroundConfiguration = backgroundConfiguration
    return cell
  }
}



// MARK: - Reactive

extension Reactive where Base: LocationResultTableViewController {

  var didSelectSearchCompletion: Observable<MKLocalSearchCompletion> {
    return base.tableView.rx
      .itemSelected
      .compactMap { [weak base] (indexPath: IndexPath) -> MKLocalSearchCompletion? in
        return base?.searchCompletions[indexPath.row]
      }
  }
}
