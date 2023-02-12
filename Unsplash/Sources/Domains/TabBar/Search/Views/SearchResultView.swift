//
//  SearchResultView.swift
//  Unsplash
//
//  Created by 안재영 on 2023/01/25.
//

import RxCocoa
import RxDataSources
import RxSwift
import SnapKit
import UIKit


final class SearchResultView: BaseView {

  // MARK: - Defines

  fileprivate struct Subject {
    let query: PublishSubject<String> = .init()
  }


  // MARK: - UI Components

  private let photoCollectionView: PhotoWaterfallCollectionView = {
    let view: PhotoWaterfallCollectionView = .init()
    view.showOwner = true
    return view
  }()

  private let collectionCollectionView: BaseCollectionView = {
    let layout: UICollectionViewFlowLayout = .init()
    layout.minimumLineSpacing = 15

    let view: BaseCollectionView = .init(frame: .zero, collectionViewLayout: layout)
    view.register(CollectionCell.self)
    return view
  }()

  private let userCollectionView: BaseCollectionView = {
    let layout: UICollectionViewFlowLayout = .init()

    let view: BaseCollectionView = .init(frame: .zero, collectionViewLayout: layout)
    view.register(UserCell.self)
    return view
  }()

  private let segmentedControl: UISegmentedControl = {
    let segmentedControl: UISegmentedControl = .init(items: ["Photos", "Collections", "Users"])
    segmentedControl.selectedSegmentIndex = 0
    return segmentedControl
  }()

  private let activityIndicatorView: UIActivityIndicatorView = {
    let view: UIActivityIndicatorView = .init(style: .large)
    view.backgroundColor = .init(red: 17/255, green: 17/255, blue: 17/255, alpha: 1.0)
    return view
  }()


  // MARK: - Properties

  private let collectionDataSource: RxCollectionViewSectionedReloadDataSource<CollectionSection> = .init(
    configureCell: { (
      dataSource: CollectionViewSectionedDataSource<CollectionSection>,
      collectionView: UICollectionView,
      indexPath: IndexPath,
      item: Collection
    ) -> UICollectionViewCell in
      let cell: CollectionCell = collectionView.dequeue(CollectionCell.self, for: indexPath)
      cell.configure(collection: item)
      return cell
    }
  )

  private let userDataSource: RxCollectionViewSectionedReloadDataSource<UserSection> = .init(
    configureCell: { (
      dataSource: CollectionViewSectionedDataSource<UserSection>,
      collectionView: UICollectionView,
      indexPath: IndexPath,
      item: User
    ) -> UICollectionViewCell in
      let cell: UserCell = collectionView.dequeue(UserCell.self, for: indexPath)
      cell.configure(user: item)
      return cell
    }
  )

  fileprivate let subject: Subject = .init()

  private let viewModel: SearchResultViewModel


  // MARK: - Initializers

  init(viewModel: SearchResultViewModel) {
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
      self.segmentedControl,
      self.photoCollectionView,
      self.collectionCollectionView,
      self.userCollectionView,
      self.activityIndicatorView
    )
  }

  override func setConstraints() {
    super.setConstraints()

    self.segmentedControl.snp.makeConstraints { (make: ConstraintMaker) in
      make.top.equalToSuperview().inset(5)
      make.left.right.equalToSuperview().inset(18)
      make.height.equalTo(30)
    }

    self.photoCollectionView.snp.makeConstraints { (make: ConstraintMaker) in
      make.top.equalTo(self.segmentedControl.snp.bottom).offset(15)
      make.left.right.bottom.equalToSuperview()
    }

    self.collectionCollectionView.snp.makeConstraints { (make: ConstraintMaker) in
      make.top.equalTo(self.segmentedControl.snp.bottom).offset(15)
      make.left.right.equalToSuperview().inset(20)
      make.bottom.equalToSuperview()
    }

    self.userCollectionView.snp.makeConstraints { (make: ConstraintMaker) in
      make.top.equalTo(self.segmentedControl.snp.bottom).offset(15)
      make.left.right.equalToSuperview().inset(20)
      make.bottom.equalToSuperview()
    }

    self.activityIndicatorView.snp.makeConstraints { (make: ConstraintMaker) in
      make.top.equalTo(self.segmentedControl.snp.bottom)
      make.left.right.bottom.equalToSuperview()
    }
  }

  override func setComponents() {
    super.setComponents()

    self.collectionCollectionView.setBackgroundView(
      image: .init(named: "collection_image"),
      text: "No collections",
      font: .pretendard.bold(25)
    )

    self.photoCollectionView.setBackgroundView(
      image: .init(named: "film_image"),
      text: "No photos",
      font: .pretendard.bold(25)
    )

    self.userCollectionView.setBackgroundView(
      image: nil,
      text: "No results",
      font: .pretendard.bold(25)
    )
  }


  // MARK: - Bind

  override func bind() {
    super.bind()

    let requestSearch: Observable<(String, Int)> = Observable
      .combineLatest(
        self.subject.query,
        self.segmentedControl.rx.selectedSegmentIndex,
        resultSelector: { (query: String, index: Int) -> (String, Int) in return (query, index) }
      )
      .share(replay: 1)

    requestSearch
      .subscribe(onNext: { [weak self] (_, index: Int) in
        self?.photoCollectionView.isHidden = (index != 0)
        self?.collectionCollectionView.isHidden = (index != 1)
        self?.userCollectionView.isHidden = (index != 2)
      })
      .disposed(by: self.disposeBag)

    let outputs: SearchResultViewModel.Outputs = self.viewModel.transform(inputs: .init(
      searchCollections: requestSearch
        .filter { (_, index: Int) -> Bool in return index == 1 }
        .map { (query: String, _) -> String in return query },
      searchPhotos: requestSearch
        .filter { (_, index: Int) -> Bool in return index == 0 }
        .map { (query: String, _) -> String in return query },
      searchUsers: requestSearch
        .filter { (_, index: Int) -> Bool in return index == 2 }
        .map { (query: String, _) -> String in return query }
    ))

    outputs.photos
      .drive(onNext: { [weak self] (photos: [Photo]) in self?.photoCollectionView.photos = photos })
      .disposed(by: self.disposeBag)

    outputs.collectionSections
      .drive(self.collectionCollectionView.rx.items(dataSource: self.collectionDataSource))
      .disposed(by: self.disposeBag)

    outputs.userSections
      .drive(self.userCollectionView.rx.items(dataSource: self.userDataSource))
      .disposed(by: self.disposeBag)

    outputs.isSearchCollectionEmpty
      .drive(onNext: { [weak self] (isEmpty: Bool) in
        self?.collectionCollectionView.backgroundView?.isHidden = !isEmpty
      })
      .disposed(by: self.disposeBag)

    outputs.isSearchPhotoEmpty
      .drive(onNext: { [weak self] (isEmpty: Bool) in
        self?.photoCollectionView.backgroundView?.isHidden = !isEmpty
      })
      .disposed(by: self.disposeBag)

    outputs.isSearchUserEmpty
      .drive(onNext: { [weak self] (isEmpty: Bool) in
        self?.userCollectionView.backgroundView?.isHidden = !isEmpty
      })
      .disposed(by: self.disposeBag)

    outputs.isSearching
      .drive(self.activityIndicatorView.rx.isAnimating)
      .disposed(by: self.disposeBag)

    self.collectionCollectionView.rx
      .setDelegate(self)
      .disposed(by: self.disposeBag)

    self.userCollectionView.rx
      .setDelegate(self)
      .disposed(by: self.disposeBag)
  }
}


// MARK: - UICollectionViewDelegate

extension SearchResultView: UICollectionViewDelegate {

  func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
    switch collectionView {
    case self.collectionCollectionView:
      let section: CollectionSection = self.collectionDataSource.sectionModels[indexPath.section]
      let collection: Collection = section.items[indexPath.row]

      WindowRouter.tabBarController?.pushCollectionPhoto(for: collection)

    case self.userCollectionView:
      let section: UserSection = self.userDataSource.sectionModels[indexPath.section]
      let user: User = section.items[indexPath.row]

      WindowRouter.tabBarController?.pushProfile(for: user)

    default:
      break
    }
  }
}


// MARK: - UICollectionViewDelegateFlowLayout

extension SearchResultView: UICollectionViewDelegateFlowLayout {

  func collectionView(
    _ collectionView: UICollectionView,
    layout collectionViewLayout: UICollectionViewLayout,
    sizeForItemAt indexPath: IndexPath
  ) -> CGSize {
    switch collectionView {
    case self.collectionCollectionView:
      return .init(width: collectionView.frame.width, height: collectionView.frame.height / 3.5)
    case self.userCollectionView:
      return .init(width: collectionView.frame.width, height: collectionView.frame.height / 7)
    default:
      return UICollectionViewFlowLayout.automaticSize
    }
  }
}


// MARK: - Reactive

extension Reactive where Base: SearchResultView {

  var query: Binder<String> {
    return Binder(self.base) { (base: SearchResultView, query: String) in
      base.subject.query.onNext(query)
    }
  }
}
