//
//  RecentSearchView.swift
//  Unsplash
//
//  Created by 안재영 on 2023/01/22.
//

import RxDataSources
import RxCocoa
import RxSwift
import SnapKit
import UIKit


final class RecentSearchView: BaseView {

  // MARK: - Defines

  fileprivate struct Subject {
    let didSelectItem: PublishSubject<String> = .init()
    let didTapClearButton: PublishSubject<Void> = .init()
  }


  // MARK: - UI Components

  private let tableView: BaseTableView = {
    let view: BaseTableView = .init(frame: .zero, style: .plain)
    view.separatorInset = .zero
    view.sectionHeaderTopPadding = 0
    view.directionalLayoutMargins = .zero
    return view
  }()


  // MARK: - Properties

  private let dataSource: RxTableViewSectionedReloadDataSource<RecentSearchSection> = .init(
    configureCell: { (
      dataSource: TableViewSectionedDataSource<RecentSearchSection>,
      tableView: UITableView,
      indexPath: IndexPath,
      item: RecentSearchSectionItem
    ) -> UITableViewCell in
      var contentConfiguration: UIListContentConfiguration = .cell()

      switch item {
      case .recent(let query):
        contentConfiguration.text = query
        contentConfiguration.image = .init(named: "search_gray_icon")

      case .trending(let keyword):
        contentConfiguration.text = keyword
        contentConfiguration.image = .init(named: "chart_arrow_up_icon")
      }

      let cell: BaseTableViewCell = .init()
      cell.contentConfiguration = contentConfiguration
      cell.backgroundConfiguration = .clear()
      cell.contentView.directionalLayoutMargins = .zero
      return cell
    }
  )

  fileprivate let subject: Subject = .init()

  private let viewModel: RecentSearchViewModel


  // MARK: - Initializers

  init(viewModel: RecentSearchViewModel) {
    self.viewModel = viewModel

    super.init(frame: .zero)

    self.backgroundColor = .init(red: 17/255, green: 17/255, blue: 17/255, alpha: 1.0)
  }

  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }


  // MARK: - Layout

  override func addSubviews() {
    super.addSubviews()

    self.add(
      self.tableView
    )
  }

  override func setConstraints() {
    super.setConstraints()

    self.tableView.snp.makeConstraints { (make: ConstraintMaker) in
      make.edges.equalToSuperview().inset(20)
    }
  }


  // MARK: - Bind

  override func bind() {
    super.bind()

    let outputs: RecentSearchViewModel.Outputs = self.viewModel.transform(inputs: .init(
      clearRecentSearchQueries: self.subject.didTapClearButton.asObservable(),
      requestSections: self.rx
        .observe(Bool.self, #keyPath(UIView.isHidden))
        .compactMap { (isHidden: Bool?) -> Bool? in return isHidden }
        .filter { (isHidden: Bool) -> Bool in return !isHidden }
        .map { _ in }
    ))

    outputs.sections
      .drive(self.tableView.rx.items(dataSource: self.dataSource))
      .disposed(by: self.disposeBag)

    self.tableView.rx
      .setDelegate(self)
      .disposed(by: self.disposeBag)
  }
}


// MARK: - UITableViewDelegate

extension RecentSearchView: UITableViewDelegate {

  func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    let section: RecentSearchSection = self.dataSource.sectionModels[indexPath.section]
    let item: RecentSearchSectionItem = section.items[indexPath.row]

    switch item {
    case .recent(let query):
      self.subject.didSelectItem.onNext(query)
    case .trending(let keyword):
      self.subject.didSelectItem.onNext(keyword)
    }
  }

  func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
    let section: RecentSearchSection = self.dataSource.sectionModels[section]
    let headerView: TitleSectionHeaderView = .init()
    headerView.title = section.title
    headerView.hideClearButton = section.hideClearButton

    headerView.rx
      .didTapClearButton
      .observeOn(MainScheduler.asyncInstance)
      .throttle(.milliseconds(500), scheduler: MainScheduler.instance)
      .bind(to: self.subject.didTapClearButton)
      .disposed(by: headerView.disposeBag)

    return headerView
  }

  func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
    let separator: UIView = .init(frame: .init(
      x: 0,
      y: 0,
      width: tableView.frame.width,
      height: 0.5
    ))
    separator.backgroundColor = tableView.separatorColor

    let view: UIView = .init()
    view.add(separator)
    return view
  }

  func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
    return 45
  }

  func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
    return 30
  }
}


// MARK: - Reactive

extension Reactive where Base: RecentSearchView {

  var didSelectItem: Observable<String> {
    return base.subject
      .didSelectItem
      .asObservable()
  }
}
