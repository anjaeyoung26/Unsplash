//
//  DetailPhotoViewController.swift
//  Unsplash
//
//  Created by 안재영 on 2023/01/11.
//

import Kingfisher
import RxCocoa
import RxDataSources
import RxSwift
import SnapKit
import UIKit


final class DetailPhotoViewController: BaseViewController {

  // MARK: - UI Components

  private let imageView: BaseImageView = {
    let view: BaseImageView = .init(image: nil)
    return view
  }()

  private let imageContainerView: UIView = {
    let view: UIView = .init()
    view.backgroundColor = .clear
    return view
  }()

  private let shareButton: UIButton = {
    var configuration: UIButton.Configuration = .plain()
    configuration.image = .init(systemName: "square.and.arrow.up")
    configuration.contentInsets.trailing = -10
    configuration.preferredSymbolConfigurationForImage = .init(pointSize: 15, weight: .medium)

    let button: UIButton = .init(configuration: configuration)
    return button
  }()

  private let infoButton: UIButton = {
    var configuration: UIButton.Configuration = .plain()
    configuration.image = .init(systemName: "info.circle")?
    configuration.baseForegroundColor = .white
    configuration.preferredSymbolConfigurationForImage = .init(pointSize: 15)

    let button: UIButton = .init(configuration: configuration)
    return button
  }()

  fileprivate let heartButton: UIButton = {
    var configuration: UIButton.Configuration = .filled()
    configuration.image = .init(systemName: "suit.heart.fill")
    configuration.cornerStyle = .capsule
    configuration.baseBackgroundColor = .black
    configuration.preferredSymbolConfigurationForImage = .init(pointSize: 17, weight: .bold)

    let button: UIButton = .init(configuration: configuration)
    button.configurationUpdateHandler = { (button: UIButton) in
      let selectedColor: UIColor = .init(
        red: 249/255,
        green: 61/255,
        blue: 46/255,
        alpha: 1.0
      )
      let updateForegroundColor: UIColor = (button.isSelected) ? selectedColor : .lightGray

      UIView.animate(
        withDuration: 0.2,
        animations: { button.configuration?.baseForegroundColor = updateForegroundColor }
      )
    }

    return button
  }()

  private let addButton: UIButton = {
    var configuration: UIButton.Configuration = .filled()
    configuration.image = .init(systemName: "plus")
    configuration.cornerStyle = .capsule
    configuration.baseBackgroundColor = .black
    configuration.preferredSymbolConfigurationForImage = .init(pointSize: 20, weight: .medium)

    let button: UIButton = .init(configuration: configuration)
    return button
  }()

  private let downloadButton: UIButton = {
    var configuration: UIButton.Configuration = .filled()
    configuration.image = .init(systemName: "arrow.down")
    configuration.cornerStyle = .capsule
    configuration.baseForegroundColor = .black
    configuration.baseBackgroundColor = .white
    configuration.preferredSymbolConfigurationForImage = .init(pointSize: 18, weight: .bold)

    let button: UIButton = .init(configuration: configuration)
    return button
  }()

  private let floatingButtonStackView: UIStackView = {
    let view: UIStackView = .init()
    view.axis = .vertical
    view.spacing = 20
    return view
  }()

  private let relatedLabel: UILabel = {
    let label: UILabel = .init()
    label.font = .boldSystemFont(ofSize: 15)
    label.text = "Related Photos"
    return label
  }()

  private let collectionView: PhotoWaterfallCollectionView = {
    let view: PhotoWaterfallCollectionView = .init()
    view.isFittingContent = true
    return view
  }()

  private let iconImageView: BaseImageView = {
    let image: UIImage? = .init(named: "app_icon_gray")
    let view: BaseImageView = .init(image: image)
    view.contentMode = .scaleAspectFit
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


  // MARK: - Properties

  private let viewModel: DetailPhotoViewModel

  fileprivate let photo: Photo


  // MARK: - Initializers

  init(viewModel: DetailPhotoViewModel, photo: Photo) {
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

    self.view.backgroundColor = .init(red: 17/255, green: 17/255, blue: 17/255, alpha: 1.0)
    self.scrollView.delegate = self
  }


  // MARK: - Layout

  override func addSubviews() {
    super.addSubviews()

    self.view.add(
      self.scrollView.with(
        self.containerView.with(
          self.imageContainerView,
          self.imageView,
          self.relatedLabel,
          self.collectionView,
          self.iconImageView
        )
      ),
      self.infoButton,
      self.floatingButtonStackView.withArranged([
        self.heartButton,
        self.addButton,
        self.downloadButton
      ])
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

    self.imageContainerView.snp.makeConstraints { (make: ConstraintMaker) in
      make.top.equalToSuperview().offset(50)
      make.left.right.equalToSuperview()
      make.height.equalTo(self.view.safeAreaLayoutGuide).multipliedBy(0.85)
    }

    self.imageView.snp.makeConstraints { (make: ConstraintMaker) in
      make.center.width.equalTo(self.imageContainerView)

      let height: CGFloat = (self.photo.height * self.view.frame.width) / self.photo.width
      make.height.equalTo(height)
    }

    self.relatedLabel.snp.makeConstraints { (make: ConstraintMaker) in
      make.top.equalTo(self.imageContainerView.snp.bottom).offset(120)
      make.left.equalToSuperview().inset(20)
    }

    self.collectionView.snp.makeConstraints { (make: ConstraintMaker) in
      make.top.equalTo(self.relatedLabel.snp.bottom).offset(20)
      make.left.right.equalToSuperview()
    }

    self.iconImageView.snp.makeConstraints { (make: ConstraintMaker) in
      make.centerX.bottom.equalToSuperview()
      make.top.equalTo(self.collectionView.snp.bottom).offset(55)
      make.size.equalTo(35)
    }

    self.infoButton.snp.makeConstraints { (make: ConstraintMaker) in
      make.left.equalToSuperview().inset(5)
      make.bottom.equalTo(self.view.safeAreaLayoutGuide)
    }

    self.floatingButtonStackView.snp.makeConstraints { (make: ConstraintMaker) in
      make.right.equalToSuperview().inset(15)
      make.bottom.equalTo(self.view.safeAreaLayoutGuide)
    }

    self.heartButton.snp.makeConstraints { (make: ConstraintMaker) in
      make.size.equalTo(55)
    }

    self.addButton.snp.makeConstraints { (make: ConstraintMaker) in
      make.size.equalTo(55)
    }

    self.downloadButton.snp.makeConstraints { (make: ConstraintMaker) in
      make.size.equalTo(55)
    }
  }

  override func setComponents() {
    super.setComponents()

    if let url: URL = .init(string: self.photo.urls.regular) {
      self.imageView.configure(url: url)
    }
  }

  override func setNavigationBar() {
    super.setNavigationBar()

    self.navigationItem.rightBarButtonItem = .init(customView: self.shareButton)

    let appearance: UINavigationBarAppearance = .init()
    appearance.configureWithTransparentBackground()
    self.navigationController?.navigationBar.standardAppearance = appearance
  }


  // MARK: - Bind

  override func bind() {
    super.bind()

    let didTapHeartButton: Observable<String> = self.heartButton.rx
      .tap
      .throttle(.milliseconds(500), scheduler: MainScheduler.instance)
      .compactMap { [weak self] _ -> String? in return self?.photo.id }
      .share(replay: 1)

    let outputs: DetailPhotoViewModel.Outputs = self.viewModel.transform(inputs: .init(
      requestActivityItem: self.shareButton.rx
        .tap
        .throttle(.milliseconds(500), scheduler: MainScheduler.instance),
      requestDetailPhoto: self.rx
        .viewDidLoad
        .compactMap { [weak self] _ -> String? in return self?.photo.id },
      downloadPhoto: self.downloadButton.rx
        .tap
        .throttle(.milliseconds(500), scheduler: MainScheduler.instance)
        .compactMap { [weak self] _ -> URL? in
          guard let downloadLink: String = self?.photo.links.download else { return nil }
          return .init(string: downloadLink)
        },
      likePhoto: didTapHeartButton.filter { [weak self] _ -> Bool in
        return !(self?.photo.likedByUser ?? false)
      },
      unlikePhoto: didTapHeartButton.filter { [weak self] _ -> Bool in
        return self?.photo.likedByUser ?? false
      }
    ))

    outputs.detailPhoto
      .drive(onNext: { [weak self] (photo: Photo) in
        self?.heartButton.isSelected = photo.likedByUser ?? false
      })
      .disposed(by: self.disposeBag)

    outputs.isDownloadingPhoto
      .drive(self.downloadButton.rx.showsActivityIndicator)
      .disposed(by: self.disposeBag)

    outputs.isPhotoDownloaded
      .drive(onNext: { (isDownloaded: Bool) in
        UINotificationFeedbackGenerator().notificationOccurred(isDownloaded ? .success : .error)
      })
      .disposed(by: self.disposeBag)

    outputs.likedByUser
      .drive(self.heartButton.rx.isSelected)
      .disposed(by: self.disposeBag)

    outputs.presentActivity
      .drive(self.rx.presentActivity)
      .disposed(by: self.disposeBag)

    outputs.presentAlert
      .drive(self.rx.presentAlert)
      .disposed(by: self.disposeBag)

    outputs.relatedPhotos
      .drive(onNext: { [weak self] (photos: [Photo]) in self?.collectionView.photos = photos })
      .disposed(by: self.disposeBag)

    self.infoButton.rx
      .tap
      .asObservable()
      .bind(to: self.rx.presentInfoPhoto)
      .disposed(by: self.disposeBag)

    self.addButton.rx
      .tap
      .bind(to: self.rx.presentAddToCollection)
      .disposed(by: self.disposeBag)
  }
}


// MARK: - UIScrollViewDelegate

extension DetailPhotoViewController: UIScrollViewDelegate {

  func scrollViewDidScroll(_ scrollView: UIScrollView) {
    let contentOffsetY: CGFloat = scrollView.contentOffset.y
    let contentHeight: CGFloat = scrollView.contentSize.height
    let frameHeight: CGFloat = scrollView.frame.size.height
    let scrollOffsetY: CGFloat = (contentOffsetY / (contentHeight - frameHeight))
    let alphaOffset: CGFloat = (scrollOffsetY * 4)
    let alpha: CGFloat = 1.0 - alphaOffset

    self.infoButton.alpha = alpha
    self.floatingButtonStackView.alpha = alpha

    if (contentOffsetY > self.relatedLabel.frame.minY) && (contentOffsetY > 0) {
      self.navigationItem.setTitleView(title: "Related Photos")
    } else {
      let subtitle: String = (self.photo.sponsorship == nil) ? "" : "Sponsored"
      self.navigationItem.setTitleView(title: self.photo.user.userName, subtitle: subtitle)
    }
  }
}


// MARK: - Reactive

extension Reactive where Base: DetailPhotoViewController {

  var presentInfoPhoto: Binder<Void> {
    return Binder(self.base) { (base: DetailPhotoViewController, _) in
      let viewController: InfoPhotoViewController = AppAssembler.resolve(
        InfoPhotoViewController.self,
        argument: base.photo
      )
      let navigationController: UINavigationController = .init(rootViewController: viewController)
      base.present(navigationController, animated: true)
    }
  }

  var presentActivity: Binder<PhotoActivityItemSource> {
    return Binder(self.base) { (
      base: DetailPhotoViewController,
      item: PhotoActivityItemSource
    ) in
      let activityViewController: UIActivityViewController = .init(
        activityItems: [item],
        applicationActivities: nil
      )

      base.present(activityViewController, animated: true)
    }
  }

  var presentAddToCollection: Binder<Void> {
    return Binder(self.base) { (base: DetailPhotoViewController, _) in
      let viewController: AddToCollectionViewController = AppAssembler.resolve(
        AddToCollectionViewController.self,
        argument: base.photo
      )

      let navigationController: UINavigationController = .init(rootViewController: viewController)
      base.present(navigationController, animated: true)
    }
  }
}
