//
//  SearchViewController.swift
//  Unsplash
//
//  Created by 안재영 on 2022/12/28.
//

import RxCocoa
import RxDataSources
import RxSwift
import SnapKit
import UIKit


final class SearchViewController: BaseViewController {

  // MARK: - UI Components

  private let searchBar: UISearchBar = {
    let searchBar: UISearchBar = .init()
    searchBar.placeholder = "Search photos, collections, users"
    searchBar.searchTextField.backgroundColor = .init(
      red: 44/255,
      green: 44/255,
      blue: 46/255,
      alpha: 1.0
    )
    return searchBar
  }()

  private let categoryTitleLabel: UILabel = {
    let label: UILabel = .init()
    label.font = .pretendard.bold(20)
    label.text = "Browse by Category"
    return label
  }()

  private let discoverTitleLabel: UILabel = {
    let label: UILabel = .init()
    label.font = .pretendard.bold(22)
    label.text = "Discover"
    return label
  }()

  private let categoryCollectionView: BaseCollectionView = {
    let layout: UICollectionViewFlowLayout = .init()
    layout.itemSize = .init(width: 115, height: 115)
    layout.scrollDirection = .horizontal

    let view: BaseCollectionView = .init(frame: .zero, collectionViewLayout: layout)
    view.register(CategoryCell.self)
    return view
  }()

  private let discoverCollectionView: PhotoWaterfallCollectionView = {
    let view: PhotoWaterfallCollectionView = .init()
    view.isFittingContent = true
    return view
  }()

  private let scrollView: UIScrollView = {
    let view: UIScrollView = .init()
    view.bounces = false
    view.showsVerticalScrollIndicator = false
    return view
  }()

  private let containerView: UIView = {
    let view: UIView = .init()
    return view
  }()

  private let recentSearchView: RecentSearchView = {
    let view: RecentSearchView = AppAssembler.resolve(RecentSearchView.self)
    view.isHidden = true
    return view
  }()

  private let searchResultView: SearchResultView = {
    let view: SearchResultView = AppAssembler.resolve(SearchResultView.self)
    view.isHidden = true
    return view
  }()


  // MARK: - Properties

  private let categoryDataSource: RxCollectionViewSectionedReloadDataSource<CategorySection> = .init(
    configureCell: { (
      dataSource: CollectionViewSectionedDataSource<CategorySection>,
      collectionView: UICollectionView,
      indexPath: IndexPath,
      item: Category
    ) -> UICollectionViewCell in
      let cell: CategoryCell = collectionView.dequeue(CategoryCell.self, for: indexPath)
      cell.configure(category: item)
      return cell
    }
  )

  private let viewModel: SearchViewModel


  // MARK: - Initializers

  init(viewModel: SearchViewModel) {
    self.viewModel = viewModel

    super.init()
  }

  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }


  // MARK: - Life Cycle

  override func viewDidLoad() {
    super.viewDidLoad()

    self.view.backgroundColor = .init(red: 17/255, green: 17/255, blue: 17/255, alpha: 1.0)
    self.discoverCollectionView.delegate = self.discoverCollectionView
  }


  // MARK: - Layout

  override func addSubviews() {
    super.addSubviews()

    self.view.add(
      self.scrollView.with(
        self.containerView.with(
          self.categoryTitleLabel,
          self.categoryCollectionView,
          self.discoverTitleLabel,
          self.discoverCollectionView
        )
      ),
      self.searchResultView,
      self.recentSearchView
    )
  }

  override func setConstraints() {
    super.setConstraints()

    self.scrollView.snp.makeConstraints { (make: ConstraintMaker) in
      make.edges.equalTo(self.view.safeAreaLayoutGuide)
    }

    self.containerView.snp.makeConstraints { (make: ConstraintMaker) in
      make.edges.equalToSuperview()
      make.width.equalTo(self.scrollView.frameLayoutGuide)
    }

    self.categoryTitleLabel.snp.makeConstraints { (make: ConstraintMaker) in
      make.top.equalToSuperview().offset(30)
      make.left.equalToSuperview().offset(20)
    }

    self.categoryCollectionView.snp.makeConstraints { (make: ConstraintMaker) in
      make.top.equalTo(self.categoryTitleLabel.snp.bottom).offset(15)
      make.left.equalToSuperview().offset(20)
      make.right.equalToSuperview()
      make.height.equalTo(240)
    }

    self.discoverTitleLabel.snp.makeConstraints { (make: ConstraintMaker) in
      make.top.equalTo(self.categoryCollectionView.snp.bottom).offset(40)
      make.left.equalToSuperview().offset(20)
    }

    self.discoverCollectionView.snp.makeConstraints { (make: ConstraintMaker) in
      make.top.equalTo(self.discoverTitleLabel.snp.bottom).offset(15)
      make.left.right.bottom.equalToSuperview()
    }

    self.searchResultView.snp.makeConstraints { (make: ConstraintMaker) in
      make.edges.equalTo(self.view.safeAreaLayoutGuide)
    }

    self.recentSearchView.snp.makeConstraints { (make: ConstraintMaker) in
      make.edges.equalTo(self.view.safeAreaLayoutGuide)
    }
  }

  override func setNavigationBar() {
    super.setNavigationBar()

    self.navigationItem.titleView = self.searchBar
    self.navigationItem.hidesSearchBarWhenScrolling = false

    let appearance: UINavigationBarAppearance = .init()
    appearance.configureWithTransparentBackground()
    self.navigationController?.navigationBar.standardAppearance = appearance
  }


  // MARK: - Bind

  override func bind() {
    super.bind()

    let outputs: SearchViewModel.Outputs = self.viewModel.transform(inputs: .init(
      requestCategorySections: self.rx
        .viewDidLoad
        .asObservable(),
      requestDiscoverSections: self.rx
        .viewDidLoad
        .asObservable(),
      requestMoreDiscoverPhotos: self.scrollView.rx
        .isReachedBottom(threshold: 15)
        .throttle(.seconds(1), scheduler: MainScheduler.instance)
        .map { _ in }
    ))

    outputs.categorySections
      .drive(self.categoryCollectionView.rx.items(dataSource: self.categoryDataSource))
      .disposed(by: self.disposeBag)

    outputs.discoveredPhotos
      .drive(onNext: { [weak self] (photos: [Photo]) in
        self?.discoverCollectionView.photos = photos
      })
      .disposed(by: self.disposeBag)

    outputs.presentAlert
      .drive(self.rx.presentAlert)
      .disposed(by: self.disposeBag)

    let searchButtonClicked: Observable<String> = self.searchBar.rx
      .searchButtonClicked
      .withLatestFrom(self.searchBar.rx.text.orEmpty)

    Observable<String>
      .merge(
        searchButtonClicked,
        self.recentSearchView.rx.didSelectItem
      )
      .do(onNext: { [weak self] (query: String) in
        self?.handleSearch(query: query)
        self?.saveRecentSearch(query: query)
      })
      .bind(to: self.searchResultView.rx.query)
      .disposed(by: self.disposeBag)

    self.searchBar.rx
      .cancelButtonClicked
      .subscribe(onNext: { [weak self] in self?.cancelEditing() })
      .disposed(by: self.disposeBag)

    self.searchBar.rx
      .textDidBeginEditing
      .subscribe(onNext: { [weak self] in self?.beginEditing() })
      .disposed(by: self.disposeBag)

    self.searchBar.rx
      .textDidEndEditing
      .subscribe(onNext: { [weak self] in self?.endEditing() })
      .disposed(by: self.disposeBag)

    self.categoryCollectionView.rx
      .modelSelected(Category.self)
      .subscribe(onNext: { (category: Category) in
        WindowRouter.tabBarController?.pushSearchKeyword(for: category.title)
      })
      .disposed(by: self.disposeBag)
  }

  // MARK: - Methods

  private func handleSearch(query: String) {
    self.searchBar.text = query
    self.searchBar.endEditing(true)
    self.searchResultView.isHidden = false
    self.recentSearchView.isHidden = true
  }

  private func cancelEditing() {
    self.searchBar.text = nil
    self.searchBar.endEditing(true)
    self.searchResultView.isHidden = true
    self.recentSearchView.isHidden = true
  }

  private func beginEditing() {
    self.searchBar.setShowsCancelButton(true, animated: true)
    self.searchResultView.isHidden = true
    self.recentSearchView.isHidden = false
  }

  private func endEditing() {
    self.searchBar.setShowsCancelButton(false, animated: true)
  }

  private func saveRecentSearch(query: String) {
    if let existIndex: Int = Setting.recentSearchQueries.firstIndex(of: query) {
      Setting.recentSearchQueries.remove(at: existIndex)
    }

    if Setting.recentSearchQueries.count > 4 {
      Setting.recentSearchQueries.removeLast()
    }

    Setting.recentSearchQueries.insert(query, at: 0)
  }
}
