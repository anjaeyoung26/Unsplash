//
//  CollectionPhotoViewController.swift
//  Unsplash
//
//  Created by 안재영 on 2023/01/28.
//

import RxCocoa
import RxDataSources
import RxSwift
import SnapKit
import UIKit


final class CollectionPhotoViewController: BaseViewController {

  // MARK: - Defines

  fileprivate struct Subject {
    let deleteCollection: PublishSubject<Collection> = .init()
    let didActionEdit: PublishSubject<Void> = .init()
    let didActionDelete: PublishSubject<Void> = .init()
    let editCollection: PublishSubject<Collection> = .init()
  }


  // MARK: - UI Components

  private let moreButton: UIButton = {
    var configuration: UIButton.Configuration = .plain()
    configuration.image = .init(systemName: "ellipsis")
    configuration.contentInsets.trailing = -10
    configuration.preferredSymbolConfigurationForImage = .init(pointSize: 16, weight: .medium)

    let button: UIButton = .init(configuration: configuration)
    button.showsMenuAsPrimaryAction = true
    return button
  }()

  private let collectionView: PhotoWaterfallCollectionView = {
    let view: PhotoWaterfallCollectionView = .init()
    view.showOwner = true
    return view
  }()


  // MARK: - Properties

  private lazy var editAction: UIAction = .init(title: "Edit") { [weak self] _ in
    self?.subject.didActionEdit.onNext(())
  }

  private lazy var deleteAction: UIAction = .init(title: "Delete", attributes: .destructive) { [weak self] _ in
    self?.subject.didActionDelete.onNext(())
  }

  private var isMyCollection: Bool {
    return self.collection.user == .me
  }

  fileprivate let subject: Subject = .init()

  private let viewModel: CollectionPhotoViewModel

  private let collection: Collection


  // MARK: - Initializers

  init(viewModel: CollectionPhotoViewModel, collection: Collection) {
    self.viewModel = viewModel
    self.collection = collection

    super.init()
  }

  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }


  // MARK: - Layout

  override func addSubviews() {
    super.addSubviews()

    self.view.add(
      self.collectionView
    )
  }

  override func setConstraints() {
    super.setConstraints()

    self.collectionView.snp.makeConstraints { (make: ConstraintMaker) in
      make.top.equalTo(self.view.safeAreaLayoutGuide)
      make.left.right.bottom.equalToSuperview()
    }
  }

  override func setComponents() {
    super.setComponents()

    self.moreButton.menu = .init(children: [self.editAction, self.deleteAction])
  }

  override func setNavigationBar() {
    super.setNavigationBar()

    self.updateNavigationTitle(collection: self.collection)

    if self.isMyCollection {
      self.navigationItem.rightBarButtonItem = .init(customView: self.moreButton)
    }
  }


  // MARK: - Bind

  override func bind() {
    super.bind()

    let outputs: CollectionPhotoViewModel.Outputs = self.viewModel.transform(inputs: .init(
      requestCollectionPhotos: self.rx
        .viewDidLoad
        .compactMap { [weak self] _ -> String? in return self?.collection.id },
      requestDeleteCollectionSheet: self.subject
        .didActionDelete
        .compactMap { [weak self] _ -> String? in return self?.collection.id }
    ))

    outputs.deleteCollection
      .drive(onNext: { [weak self] in self?.dismiss(animated: true) })
      .disposed(by: self.disposeBag)

    outputs.presentAlert
      .drive(self.rx.presentAlert)
      .disposed(by: self.disposeBag)

    outputs.presentDeleteCollectionSheet
      .drive(self.rx.presentObservableBooleanAlert)
      .disposed(by: self.disposeBag)

    outputs.photos
      .drive(onNext: { [weak self] (photos: [Photo]) in self?.collectionView.photos = photos })
      .disposed(by: self.disposeBag)

    self.subject
      .didActionEdit
      .map { [weak self] _ -> Collection? in return self?.collection }
      .bind(to: self.rx.presentEditCollection)
      .disposed(by: self.disposeBag)

    self.subject
      .editCollection
      .subscribe(onNext: { [weak self] (collection: Collection) in
        self?.updateNavigationTitle(collection: collection)
      })
      .disposed(by: self.disposeBag)
  }


  // MARK: - Methods (Private)

  private func updateNavigationTitle(collection: Collection) {
    let subtitle: String = "Curated by " + (collection.user?.name ?? "User")
    self.navigationItem.setTitleView(title: collection.title, subtitle: subtitle)
  }
}


// MARK: - Reactive

extension Reactive where Base: CollectionPhotoViewController {

  var presentEditCollection: Binder<Collection?> {
    return Binder(self.base) { (
      base: CollectionPhotoViewController,
      collection: Collection?
    ) in
      let viewController: EditCollectionViewController = AppAssembler.resolve(
        EditCollectionViewController.self,
        argument: collection
      )

      viewController.rx
        .editedCollection
        .bind(to: base.subject.editCollection)
        .disposed(by: viewController.disposeBag)

      let navigationController: UINavigationController = .init(rootViewController: viewController)
      base.present(navigationController, animated: true)
    }
  }
}

