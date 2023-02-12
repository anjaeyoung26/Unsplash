//
//  ProfileViewController.swift
//  Unsplash
//
//  Created by 안재영 on 2022/12/28.
//

import Kingfisher
import RxCocoa
import RxDataSources
import RxSwift
import SnapKit
import UIKit


final class ProfileViewController: BaseViewController {

  // MARK: - Defines

  private struct Subject {
    let didActionAccountSettings: PublishSubject<Void> = .init()
    let didActionLogOut: PublishSubject<Void> = .init()
  }


  // MARK: - UI Components

  private let shareButton: UIButton = {
    var configuration: UIButton.Configuration = .plain()
    configuration.image = .init(systemName: "square.and.arrow.up")
    configuration.contentInsets.trailing = -8
    configuration.preferredSymbolConfigurationForImage = .init(pointSize: 15, weight: .medium)

    let button: UIButton = .init(configuration: configuration)
    return button
  }()

  private let moreButton: UIButton = {
    var configuration: UIButton.Configuration = .plain()
    configuration.image = .init(systemName: "ellipsis")
    configuration.contentInsets.trailing = 8
    configuration.preferredSymbolConfigurationForImage = .init(pointSize: 16, weight: .medium)

    let button: UIButton = .init(configuration: configuration)
    button.showsMenuAsPrimaryAction = true
    return button
  }()

  private let statButton: UIButton = {
    var configuration: UIButton.Configuration = .plain()
    configuration.image = .init(systemName: "chart.line.uptrend.xyaxis")
    configuration.contentInsets.leading = -8
    configuration.preferredSymbolConfigurationForImage = .init(pointSize: 16, weight: .medium)

    let button: UIButton = .init(configuration: configuration)
    return button
  }()

  private let locationButton: UIButton = {
    let configuration: UIButton.Configuration = .profileContent(imageName: "mappin.circle")
    let button: UIButton = .init(configuration: configuration)
    return button
  }()

  private let portfolioButton: UIButton = {
    let configuration: UIButton.Configuration = .profileContent(imageName: "globe.americas")
    let button: UIButton = .init(configuration: configuration)
    return button
  }()

  private let profileContentStackView: UIStackView = {
    let view: UIStackView = .init()
    view.axis = .vertical
    view.spacing = 10
    view.alignment = .leading
    return view
  }()

  private let userPhotoCollectionView: PhotoWaterfallCollectionView = {
    let view: PhotoWaterfallCollectionView = .init()
    view.showOwner = true
    view.waterfallLayout.columnCount = 1
    return view
  }()

  private let likePhotoCollectionView: PhotoWaterfallCollectionView = {
    let view: PhotoWaterfallCollectionView = .init()
    view.showOwner = true
    view.waterfallLayout.columnCount = 1
    return view
  }()

  private let collectionCollectionView: BaseCollectionView = {
    let layout: UICollectionViewFlowLayout = .init()
    layout.minimumLineSpacing = 15

    let view: BaseCollectionView = .init(frame: .zero, collectionViewLayout: layout)
    view.register(CollectionCell.self)
    return view
  }()

  private let segmentedControl: UISegmentedControl = {
    let segmentedControl: UISegmentedControl = .init(items: ["Photos", "Likes", "Collections"])
    segmentedControl.selectedSegmentIndex = 0
    return segmentedControl
  }()

  private let activityIndicatorView: UIActivityIndicatorView = {
    let view: UIActivityIndicatorView = .init(style: .large)
    view.backgroundColor = .init(red: 17/255, green: 17/255, blue: 17/255, alpha: 1.0)
    return view
  }()

  private let profileContainerView: UIView = {
    let view: UIView = .init()
    view.backgroundColor = .init(red: 25/255, green: 25/255, blue: 25/255, alpha: 1.0)
    return view
  }()

  private let nameLabel: UILabel = {
    let label: UILabel = .init()
    label.font = .pretendard.bold(23)
    label.adjustsFontSizeToFitWidth = true
    return label
  }()

  private let profileImageView: BaseImageView = {
    let view: BaseImageView = .init(image: nil)
    view.cornerType = .circle
    view.options = [
      .transition(ImageTransition.fade(0.5)),
      .forceTransition
    ]
    return view
  }()


  // MARK: - Properties

  private lazy var accountSettingsAction: UIAction = .init(title: "Account Settings") { [weak self] _ in
    self?.subject.didActionAccountSettings.onNext(())
  }

  private lazy var logOutAction: UIAction = .init(title: "Log Out") { [weak self] _ in
    self?.subject.didActionLogOut.onNext(())
  }

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

  private var isMyProfile: Bool {
    return self.user == .me
  }

  private let subject: Subject = .init()

  private let viewModel: ProfileViewModel

  private var user: User?


  // MARK: - Initializers

  init(viewModel: ProfileViewModel, user: User?) {
    self.viewModel = viewModel
    self.user = user
    
    super.init()
  }

  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }


  // MARK: - Life Cycle

  override func viewDidLoad() {
    super.viewDidLoad()

    self.view.backgroundColor = .init(red: 17/255, green: 17/255, blue: 17/255, alpha: 1.0)
  }


  // MARK: - Layout

  override func addSubviews() {
    super.addSubviews()

    self.view.add(
      self.profileContainerView.with(
        self.profileImageView,
        self.profileContentStackView.withArranged([
          self.nameLabel,
          self.locationButton,
          self.portfolioButton
        ])
      ),
      self.segmentedControl,
      self.userPhotoCollectionView,
      self.likePhotoCollectionView,
      self.collectionCollectionView,
      self.activityIndicatorView
    )
  }

  override func setConstraints() {
    super.setConstraints()

    self.profileContainerView.snp.makeConstraints { (make: ConstraintMaker) in
      make.top.left.right.equalToSuperview()
      make.height.equalTo(300)
    }

    self.profileImageView.snp.makeConstraints { (make: ConstraintMaker) in
      make.left.equalToSuperview().inset(15)
      make.bottom.equalTo(self.profileContentStackView.snp.top).offset(-10)
      make.size.equalTo(64)
    }

    self.profileContentStackView.snp.makeConstraints { (make: ConstraintMaker) in
      make.left.right.equalToSuperview().inset(15)
      make.bottom.equalToSuperview().inset(18)
    }

    self.nameLabel.snp.makeConstraints { (make: ConstraintMaker) in
      make.height.equalTo(30)
    }

    self.locationButton.snp.makeConstraints { (make: ConstraintMaker) in
      make.height.equalTo(25)
    }

    self.portfolioButton.snp.makeConstraints { (make: ConstraintMaker) in
      make.height.equalTo(15)
    }

    self.segmentedControl.snp.makeConstraints { (make: ConstraintMaker) in
      make.top.equalTo(self.profileContainerView.snp.bottom).offset(15)
      make.left.right.equalToSuperview().inset(18)
      make.height.equalTo(30)
    }

    self.userPhotoCollectionView.snp.makeConstraints { (make: ConstraintMaker) in
      make.top.equalTo(self.segmentedControl.snp.bottom).offset(15)
      make.left.right.bottom.equalToSuperview()
    }

    self.likePhotoCollectionView.snp.makeConstraints { (make: ConstraintMaker) in
      make.top.equalTo(self.segmentedControl.snp.bottom).offset(15)
      make.left.right.bottom.equalToSuperview()
    }

    self.collectionCollectionView.snp.makeConstraints { (make: ConstraintMaker) in
      make.top.equalTo(self.segmentedControl.snp.bottom).offset(18)
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
      textColor: .lightGray
    )

    self.likePhotoCollectionView.setBackgroundView(
      image: .init(named: "film_image"),
      text: "No photos",
      textColor: .lightGray
    )

    self.userPhotoCollectionView.setBackgroundView(
      image: .init(named: "film_image"),
      text: "No photos",
      textColor: .lightGray
    )

    self.setProfile(user: self.user)
    self.collectionCollectionView.backgroundView?.isHidden = true
    self.likePhotoCollectionView.backgroundView?.isHidden = true
    self.userPhotoCollectionView.backgroundView?.isHidden = true
    self.moreButton.menu = .init(children: [self.accountSettingsAction, self.logOutAction])
  }

  override func setNavigationBar() {
    super.setNavigationBar()

    self.navigationItem.rightBarButtonItem = .init(customView: self.shareButton)

    if self.isMyProfile {
      self.navigationItem.rightBarButtonItems?.append(.init(customView: self.moreButton))
      self.navigationItem.leftBarButtonItem = .init(customView: self.statButton)
    }

    let appearance: UINavigationBarAppearance = .init()
    appearance.configureWithTransparentBackground()
    self.navigationController?.navigationBar.standardAppearance = appearance
  }


  // MARK: - Bind

  override func bind() {
    super.bind()

    let requestProfile: Observable<User> = self.rx
      .viewDidLoad
      .compactMap { [weak self] _ -> User? in return self?.user }

    let outputs: ProfileViewModel.Outputs = self.viewModel.transform(inputs: .init(
      requestActivityItem: self.shareButton.rx
        .tap
        .throttle(.milliseconds(500), scheduler: MainScheduler.instance)
        .map { [weak self] _ -> User? in return self?.user },
      requestOtherProfile: requestProfile
        .filter { [weak self] _ -> Bool in return !(self?.isMyProfile ?? false) },
      requestMyProfile: requestProfile
        .filter { [weak self] _ -> Bool in return (self?.isMyProfile ?? false) },
      requestLogOut: self.subject.didActionLogOut.asObservable()
    ))

    outputs.collectionSections
      .drive(self.collectionCollectionView.rx.items(dataSource: self.collectionDataSource))
      .disposed(by: self.disposeBag)

    outputs.isCollectionEmpty
      .drive(onNext: { [weak self] (isEmpty: Bool) in
        self?.collectionCollectionView.backgroundView?.isHidden = !isEmpty
      })
      .disposed(by: self.disposeBag)

    outputs.isLikePhotoEmpty
      .drive(onNext: { [weak self] (isEmpty: Bool) in
        self?.likePhotoCollectionView.backgroundView?.isHidden = !isEmpty
      })
      .disposed(by: self.disposeBag)

    outputs.isUserPhotoEmpty
      .drive(onNext: { [weak self] (isEmpty: Bool) in
        self?.userPhotoCollectionView.backgroundView?.isHidden = !isEmpty
      })
      .disposed(by: self.disposeBag)

    outputs.isLoadingProfile
      .drive(self.activityIndicatorView.rx.isAnimating)
      .disposed(by: self.disposeBag)

    outputs.likePhotos
      .drive(onNext: { [weak self] (photos: [Photo]) in
        self?.likePhotoCollectionView.photos = photos
      })
      .disposed(by: self.disposeBag)

    outputs.logOut
      .drive(onNext: {
        let loginViewController: LoginViewController = AppAssembler.resolve(LoginViewController.self)

        WindowRouter.window?.rootViewController = loginViewController
      })
      .disposed(by: self.disposeBag)

    outputs.presentActivity
      .drive(self.rx.presentActivity)
      .disposed(by: self.disposeBag)

    outputs.presentAlert
      .drive(self.rx.presentAlert)
      .disposed(by: self.disposeBag)

    outputs.userPhotos
      .drive(onNext: { [weak self] (photos: [Photo]) in
        self?.userPhotoCollectionView.photos = photos
      })
      .disposed(by: self.disposeBag)

    self.collectionCollectionView.rx
      .setDelegate(self)
      .disposed(by: self.disposeBag)

    self.statButton.rx
      .tap
      .subscribe(onNext: { _ in WindowRouter.tabBarController?.pushMyStat() })
      .disposed(by: self.disposeBag)

    self.segmentedControl.rx
      .selectedSegmentIndex
      .subscribe(onNext: { [weak self] (index: Int) in
        self?.userPhotoCollectionView.isHidden = (index != 0)
        self?.likePhotoCollectionView.isHidden = (index != 1)
        self?.collectionCollectionView.isHidden = (index != 2)
      })
      .disposed(by: self.disposeBag)

    self.subject
      .didActionAccountSettings
      .subscribe(onNext: {
        WindowRouter.tabBarController?.presentAccountSettings()
      })
      .disposed(by: self.disposeBag)
  }


  // MARK: - Methods (Private)

  private func setProfile(user: User?) {
    if let urlString: String = user?.profileImage?.medium,
       let url: URL = .init(string: urlString) {
      self.profileImageView.configure(url: url)
    }

    self.nameLabel.text = user?.name
    self.locationButton.isHidden = user?.location == nil
    self.portfolioButton.isHidden = user?.portfolioURL == nil
    self.locationButton.configuration?.title = user?.location
    self.portfolioButton.configuration?.title = user?.portfolioURL
  }
}


// MARK: - UICollectionViewDelegate

extension ProfileViewController: UICollectionViewDelegate {

  func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
    let section: CollectionSection = self.collectionDataSource.sectionModels[indexPath.section]
    let collection: Collection = section.items[indexPath.row]

    WindowRouter.tabBarController?.pushCollectionPhoto(for: collection)
  }
}


// MARK: - UICollectionViewDelegateFlowLayout

extension ProfileViewController: UICollectionViewDelegateFlowLayout {

  func collectionView(
    _ collectionView: UICollectionView,
    layout collectionViewLayout: UICollectionViewLayout,
    sizeForItemAt indexPath: IndexPath
  ) -> CGSize {
    return .init(width: collectionView.frame.width, height: collectionView.frame.height / 3.5)
  }
}


// MARK: - UIButton.Configuration Extension (Private)

extension UIButton.Configuration {

  static func profileContent(imageName: String) -> UIButton.Configuration {
    var configuration: UIButton.Configuration = .plain()
    configuration.image = .init(systemName: imageName)
    configuration.imagePadding = 10
    configuration.contentInsets.leading = -2
    configuration.baseForegroundColor = .lightGray
    configuration.preferredSymbolConfigurationForImage = .init(pointSize: 10, weight: .bold)

    configuration.titleTextAttributesTransformer = .init({ (
      container: AttributeContainer
    ) -> AttributeContainer in
      var container: AttributeContainer = container
      container.font = .systemFont(ofSize: 15)
      return container
    })

    return configuration
  }
}


// MARK: - Reactive

extension Reactive where Base: ProfileViewController {

  var presentActivity: Binder<ProfileActivityItemSource> {
    return Binder(self.base) { (
      base: ProfileViewController,
      item: ProfileActivityItemSource
    ) in
      let activityViewController: UIActivityViewController = .init(
        activityItems: [item],
        applicationActivities: nil
      )

      DispatchQueue.main.async {
        base.present(activityViewController, animated: true)
      }
    }
  }
}
