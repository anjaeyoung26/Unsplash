//
//  AddToCollectionViewController.swift
//  Unsplash
//
//  Created by 안재영 on 2023/02/07.
//

import RxCocoa
import RxDataSources
import RxSwift
import SnapKit
import UIKit


final class AddToCollectionViewController: BaseViewController {

  // MARK: - Defines

  fileprivate struct Subject {
    let manualSelectCollection: PublishSubject<Collection> = .init()
    let newCollection: PublishSubject<Collection> = .init()
  }


  // MARK: - UI Components

  private let closeButton: UIButton = {
    var configuration: UIButton.Configuration = .plain()
    configuration.title = "Close"
    configuration.contentInsets.leading = -2

    let button: UIButton = .init(configuration: configuration)
    return button
  }()

  private let newButton: UIButton = {
    var configuration: UIButton.Configuration = .plain()
    configuration.title = "New"
    configuration.contentInsets.trailing = -2

    let button: UIButton = .init(configuration: configuration)
    return button
  }()

  private let searchBar: UISearchBar = {
    let searchBar: UISearchBar = .init()
    searchBar.placeholder = "Search Collections"
    searchBar.searchBarStyle = .minimal
    return searchBar
  }()

  private let tableView: BaseTableView = {
    let view: BaseTableView = .init()
    view.separatorStyle = .none
    view.allowsMultipleSelection = true
    view.register(AddToCollectionCell.self)
    return view
  }()

  private let activityIndicatorView: UIActivityIndicatorView = {
    let view: UIActivityIndicatorView = .init(style: .large)
    view.backgroundColor = .init(red: 28/255, green: 28/255, blue: 30/255, alpha: 1.0)
    return view
  }()


  // MARK: - Properties

  private let dataSource: RxTableViewSectionedReloadDataSource<CollectionSection> = .init(
    configureCell: { (
      dataSource: TableViewSectionedDataSource<CollectionSection>,
      tableView: UITableView,
      indexPath: IndexPath,
      item: Collection
    ) -> UITableViewCell in
      let cell: AddToCollectionCell = tableView.dequeue(AddToCollectionCell.self, for: indexPath)
      cell.configure(collection: item)
      return cell
    }
  )

  private var enumeratedSections: EnumeratedSequence<[CollectionSection]> {
    return self.dataSource.sectionModels.enumerated()
  }

  fileprivate let subject: Subject = .init()

  private let viewModel: AddToCollectionViewModel

  private let photo: Photo


  // MARK: - Initializers

  init(viewModel: AddToCollectionViewModel, photo: Photo) {
    self.viewModel = viewModel
    self.photo = photo

    super.init()
  }

  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }


  // MARK: - Life Cycle

  override func viewDidLoad() {
    super.viewDidLoad()

    self.view.backgroundColor = .init(red: 28/255, green: 28/255, blue: 30/255, alpha: 1.0)
  }


  // MARK: - Layout

  override func addSubviews() {
    super.addSubviews()

    self.view.add(
      self.searchBar,
      self.tableView,
      self.activityIndicatorView
    )
  }

  override func setConstraints() {
    super.setConstraints()

    self.searchBar.snp.makeConstraints { (make: ConstraintMaker) in
      make.top.equalTo(self.view.safeAreaLayoutGuide)
      make.left.right.equalToSuperview().inset(10)
      make.height.equalTo(50)
    }

    self.tableView.snp.makeConstraints { (make: ConstraintMaker) in
      make.top.equalTo(self.searchBar.snp.bottom)
      make.left.right.bottom.equalToSuperview().inset(20)
    }

    self.activityIndicatorView.snp.makeConstraints { (make: ConstraintMaker) in
      make.edges.equalTo(self.tableView)
    }
  }

  override func setNavigationBar() {
    super.setNavigationBar()

    self.navigationItem.setTitleView(title: "Add to Collection")
    self.navigationItem.leftBarButtonItem = .init(customView: self.closeButton)
    self.navigationItem.rightBarButtonItem = .init(customView: self.newButton)
  }


  // MARK: - Bind

  override func bind() {
    super.bind()

    let didSelectCollection: Observable<Collection> = .merge(
      self.tableView.rx.modelSelected(Collection.self).asObservable(),
      self.subject.manualSelectCollection.asObservable()
    )

    let outputs: AddToCollectionViewModel.Outputs = self.viewModel.transform(inputs: .init(
      addPhotoToCollection: didSelectCollection
        .map(self.createUpdatePhotoToCollectionParameter),
      removePhotoInCollection: self.tableView.rx
        .modelDeselected(Collection.self)
        .map(self.createUpdatePhotoToCollectionParameter),
      requestUserCollections: self.rx
        .viewDidLoad
        .compactMap { _ -> User? in return .me }
    ))

    outputs.collectionSections
      .drive(self.tableView.rx.items(dataSource: self.dataSource))
      .disposed(by: self.disposeBag)

    outputs.isLoadingSections
      .drive(self.activityIndicatorView.rx.isAnimating)
      .disposed(by: self.disposeBag)

    outputs.presentAlert
      .drive(self.rx.presentAlert)
      .disposed(by: self.disposeBag)

    outputs.updateCollection
      .drive(onNext: { [weak self] (collection: Collection) in
        self?.updateSectionItem(collection)
      })
      .disposed(by: self.disposeBag)

    self.closeButton.rx
      .tap
      .subscribe(onNext: { [weak self] in self?.dismiss(animated: true) })
      .disposed(by: self.disposeBag)

    self.newButton.rx
      .tap
      .bind(to: self.rx.presentEditCollection)
      .disposed(by: self.disposeBag)

    self.subject
      .newCollection
      .subscribe(onNext: { [weak self] (collection: Collection) in
        self?.insertSectionItem(collection, section: 0)
        self?.selectCollection(collection)
      })
      .disposed(by: self.disposeBag)
  }


  // MARK: - Methods (Private)

  private func createUpdatePhotoToCollectionParameter(
    collection: Collection
  ) -> Parameter.UpdatePhotoToCollection {
    return .init(collectionID: collection.id, photoID: self.photo.id)
  }

  private func insertSectionItem(_ collection: Collection, section: Int) {
    var insertedSection: CollectionSection = self.dataSource.sectionModels[section]
    insertedSection.items.insert(collection, at: 0)

    self.dataSource.setSections([insertedSection])
    self.tableView.reloadSections([section], animationStyle: .automatic)
  }

  private func updateSectionItem(_ collection: Collection) {
    for (index, section) in self.enumeratedSections {
      if let row: Int = section.items.firstIndex(of: collection) {
        let indexPath: IndexPath = .init(row: row, section: index)
        let cell: AddToCollectionCell? = tableView.cellForRow(at: indexPath) as? AddToCollectionCell
        cell?.configure(collection: collection)
      }
    }
  }

  private func selectCollection(_ collection: Collection) {
    for (index, section) in self.enumeratedSections {
      if let row: Int = section.items.firstIndex(of: collection) {
        let indexPath: IndexPath = .init(row: row, section: index)
        self.tableView.selectRow(
          at: indexPath,
          animated: true,
          scrollPosition: .none
        )

        self.subject.manualSelectCollection.onNext(collection)
        break
      }
    }
  }
}


// MARK: - Reactive

extension Reactive where Base: AddToCollectionViewController {

  var presentEditCollection: Binder<Void> {
    return Binder(self.base) { (base: AddToCollectionViewController, _) in
      let argument: Optional<Collection> = nil
      let viewController: EditCollectionViewController = AppAssembler.resolve(
        EditCollectionViewController.self,
        argument: argument
      )

      viewController.rx
        .editedCollection
        .bind(to: base.subject.newCollection)
        .disposed(by: viewController.disposeBag)

      let navigationController: UINavigationController = .init(rootViewController: viewController)
      base.present(navigationController, animated: true)
    }
  }
}
