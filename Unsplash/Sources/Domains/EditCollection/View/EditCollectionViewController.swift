//
//  EditCollectionViewController.swift
//  Unsplash
//
//  Created by 안재영 on 2023/02/08.
//

import RxCocoa
import RxDataSources
import RxSwift
import SnapKit
import UIKit


final class EditCollectionViewController: BaseViewController {

  // MARK: - Defines

  fileprivate struct Subject {
    let description: BehaviorSubject<String?> = .init(value: nil)
    let editedCollection: PublishSubject<Collection> = .init()
    let isPrivate: BehaviorSubject<Bool?> = .init(value: nil)
    let title: PublishSubject<String> = .init()
  }


  // MARK: - UI Components

  private let closeButton: UIButton = {
    var configuration: UIButton.Configuration = .plain()
    configuration.title = "Close"
    configuration.contentInsets.leading = -2

    let button: UIButton = .init(configuration: configuration)
    return button
  }()

  private let saveButton: UIButton = {
    var configuration: UIButton.Configuration = .plain()
    configuration.title = "Save"
    configuration.contentInsets.trailing = -2

    let button: UIButton = .init(configuration: configuration)
    return button
  }()

  private let tableView: BaseTableView = {
    let view: BaseTableView = .init(frame: .zero, style: .insetGrouped)
    view.tintColor = .white
    view.layer.cornerRadius = 10
    view.layer.masksToBounds = true
    view.register(SwitchCell.self)
    view.register(TextViewCell.self)
    view.register(TextFieldCell.self)
    return view
  }()


  // MARK: - Properties

  private lazy var dataSource: RxTableViewSectionedReloadDataSource<EditCollectionSection> = .init(
    configureCell: { [weak self] (
      dataSource: TableViewSectionedDataSource<EditCollectionSection>,
      tableView: UITableView,
      indexPath: IndexPath,
      item: EditCollectionSectionItem
    ) -> UITableViewCell in
      guard let self = self else { return .init() }

      let backgroundColor: UIColor = .init(
        red: 44/255,
        green: 44/255,
        blue: 47/255,
        alpha: 1.0
      )

      switch item {
      case .description(let description):
        let cell: TextViewCell = tableView.dequeue(TextViewCell.self, for: indexPath)
        cell.text = description
        cell.placeholder = "Description (Optional)"
        cell.backgroundColor = backgroundColor
        cell.rx
          .text
          .bind(to: self.subject.description)
          .disposed(by: cell.disposeBag)

        return cell

      case .isPrivate(let isPrivate):
        let cell: SwitchCell = tableView.dequeue(SwitchCell.self, for: indexPath)
        cell.title = "Private"
        cell.subtitle = "Only accessible through a direct link"
        cell.isSwitchOn = isPrivate
        cell.backgroundColor = backgroundColor
        cell.rx
          .isSwitchOn
          .bind(to: self.subject.isPrivate)
          .disposed(by: self.disposeBag)

        return cell

      case .title(let title):
        let cell: TextFieldCell = tableView.dequeue(TextFieldCell.self, for: indexPath)
        cell.text = title
        cell.placeholder = "Title"
        cell.backgroundColor = backgroundColor
        cell.clearButtonMode = .never
        cell.rx
          .text
          .orEmpty
          .bind(to: self.subject.title)
          .disposed(by: cell.disposeBag)

        return cell
      }
    }
  )

  fileprivate let subject: Subject = .init()

  private let viewModel: EditCollectionViewModel

  private let collection: Collection?


  // MARK: - Initializers

  init(viewModel: EditCollectionViewModel, collection: Collection?) {
    self.viewModel = viewModel
    self.collection = collection

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
      self.tableView
    )
  }

  override func setConstraints() {
    super.setConstraints()

    self.tableView.snp.makeConstraints { (make: ConstraintMaker) in
      make.top.equalTo(self.view.safeAreaLayoutGuide)
      make.left.right.bottom.equalToSuperview().inset(1)
    }
  }

  override func setNavigationBar() {
    super.setNavigationBar()

    self.navigationItem.setTitleView(title: "Edit Collection")
    self.navigationItem.leftBarButtonItem = .init(customView: self.closeButton)
    self.navigationItem.rightBarButtonItem = .init(customView: self.saveButton)
  }


  // MARK: - Bind

  override func bind() {
    super.bind()

    let createCollectionParameter: Observable<Parameter.CreateCollection> = self.createCreateCollectionParameter()

    let updateCollectionParameter: Observable<Parameter.UpdateCollection> = self.createUpdateCollectionParameter()

    let didTapSaveButton: Observable<Void> = self.saveButton.rx
      .tap
      .throttle(.milliseconds(500), scheduler: MainScheduler.instance)
      .share(replay: 1)

    let outputs: EditCollectionViewModel.Outputs = self.viewModel.transform(inputs: .init(
      requestSections: self.rx
        .viewDidLoad
        .map { [weak self] _ -> Collection? in return self?.collection },
      createCollection: didTapSaveButton
        .filter { [weak self] _ -> Bool in return self?.collection == nil }
        .withLatestFrom(createCollectionParameter),
      updateCollection: didTapSaveButton
        .filter { [weak self] _ -> Bool in return self?.collection != nil }
        .withLatestFrom(updateCollectionParameter)
    ))

    outputs.editedCollection
      .drive(onNext: { [weak self] (collection: Collection) in
        self?.subject.editedCollection.onNext(collection)
        self?.dismiss(animated: true)
      })
      .disposed(by: self.disposeBag)

    outputs.presentAlert
      .drive(self.rx.presentAlert)
      .disposed(by: self.disposeBag)

    outputs.sections
      .drive(self.tableView.rx.items(dataSource: self.dataSource))
      .disposed(by: self.disposeBag)

    self.tableView.rx
      .setDelegate(self)
      .disposed(by: self.disposeBag)

    self.closeButton.rx
      .tap
      .subscribe(onNext: { [weak self] in self?.dismiss(animated: true) })
      .disposed(by: self.disposeBag)

    self.subject
      .title
      .map { (title: String) -> Bool in return title.isNotEmpty }
      .bind(to: self.saveButton.rx.isEnabled)
      .disposed(by: self.disposeBag)
  }


  // MARK: - Methods (Private)

  private func createCreateCollectionParameter() -> Observable<Parameter.CreateCollection> {
    return .combineLatest(
      self.subject.description,
      self.subject.isPrivate,
      self.subject.title,
      resultSelector: { (
        description: String?,
        isPrivate: Bool?,
        title: String
      ) -> Parameter.CreateCollection in
        return .init(
          description: description,
          isPrivate: isPrivate,
          title: title
        )
      }
    )
  }

  private func createUpdateCollectionParameter() -> Observable<Parameter.UpdateCollection> {
    guard let collectionID: String = self.collection?.id else { return .empty() }
    return .combineLatest(
      self.subject.description,
      self.subject.isPrivate,
      self.subject.title,
      resultSelector: { (
        description: String?,
        isPrivate: Bool?,
        title: String
      ) -> Parameter.UpdateCollection in
        return .init(
          id: collectionID,
          description: description,
          isPrivate: isPrivate,
          title: title
        )
      }
    )
  }
}


// MARK: - UITableViewDelegate

extension EditCollectionViewController: UITableViewDelegate {

  func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
    let section: EditCollectionSection = self.dataSource.sectionModels[indexPath.section]
    let item: EditCollectionSectionItem = section.items[indexPath.row]

    switch item {
    case .description:
      return 120
    case .isPrivate:
      return 70
    case .title:
      return 45
    }
  }
}


// MARK: - Reactive

extension Reactive where Base: EditCollectionViewController {

  var editedCollection: Observable<Collection> {
    return base.subject
      .editedCollection
      .asObservable()
  }
}
