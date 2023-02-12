//
//  ContributeViewController.swift
//  Unsplash
//
//  Created by 안재영 on 2022/12/28.
//

import RxCocoa
import RxDataSources
import RxGesture
import RxSwift
import SnapKit
import UIKit


final class ContributeViewController: BaseViewController {

  // MARK: - UI Components

  private let titleLabel: UILabel = {
    let label: UILabel = .init()
    label.font = .pretendard.bold(22)
    label.text = "Contribute to Unsplash"
    return label
  }()

  private let submitToTopicsLabel: UILabel = {
    let label: UILabel = .init()
    label.font = .pretendard.bold(16)
    label.text = "Submit to topics"
    return label
  }()

  private let latestFromTheBlogLabel: UILabel = {
    let label: UILabel = .init()
    label.font = .pretendard.bold(16)
    label.text = "Latest from the blog"
    return label
  }()

  private let blogCollectionView: BaseCollectionView = {
    let layout: UICollectionViewFlowLayout = .init()
    layout.itemSize = .init(width: 250, height: 215)
    layout.scrollDirection = .horizontal

    let view: BaseCollectionView = .init(frame: .zero, collectionViewLayout: layout)
    view.register(BlogCell.self)
    return view
  }()

  private let topicCollectionView: BaseCollectionView = {
    let layout: UICollectionViewFlowLayout = .init()
    layout.itemSize = .init(width: 155, height: 115)
    layout.scrollDirection = .horizontal

    let view: BaseCollectionView = .init(frame: .zero, collectionViewLayout: layout)
    view.register(TopicCell.self)
    return view
  }()

  private let activityIndicatorView: UIActivityIndicatorView = {
    let view: UIActivityIndicatorView = .init(style: .large)
    view.backgroundColor = .init(red: 17/255, green: 17/255, blue: 17/255, alpha: 1.0)
    return view
  }()

  private let scrollView: UIScrollView = {
    let view: UIScrollView = .init()
    view.showsVerticalScrollIndicator = false
    return view
  }()

  private let containerView: UIView = {
    let view: UIView = .init()
    return view
  }()

  private let uploadPhotoView: UploadPhotoView = .init()


  // MARK: - Properties

  private let blogDataSource: RxCollectionViewSectionedReloadDataSource<BlogSection> = .init(
    configureCell: { (
      dataSource: CollectionViewSectionedDataSource<BlogSection>,
      collectionView: UICollectionView,
      indexPath: IndexPath,
      item: Blog
    ) -> UICollectionViewCell in
      let cell: BlogCell = collectionView.dequeue(BlogCell.self, for: indexPath)
      cell.configure(blog: item)
      return cell
    }
  )

  private let topicDataSource: RxCollectionViewSectionedReloadDataSource<TopicSection> = .init(
    configureCell: { (
      dataSource: CollectionViewSectionedDataSource<TopicSection>,
      collectionView: UICollectionView,
      indexPath: IndexPath,
      item: Topic
    ) -> UICollectionViewCell in
      let cell: TopicCell = collectionView.dequeue(TopicCell.self, for: indexPath)
      cell.configure(topic: item)
      return cell
    }
  )

  fileprivate let sheetTransitionController: SheetTransitioningController = .init()

  private let viewModel: ContributeViewModel


  // MARK: - Initializers

  init(viewModel: ContributeViewModel) {
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
  }

  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)

    self.navigationController?.isNavigationBarHidden = true
  }

  override func viewWillDisappear(_ animated: Bool) {
    super.viewWillDisappear(animated)

    self.navigationController?.isNavigationBarHidden = false
  }


  // MARK: - Layout

  override func addSubviews() {
    super.addSubviews()

    self.view.add(
      self.titleLabel,
      self.scrollView.with(
        self.containerView.with(
          self.uploadPhotoView,
          self.submitToTopicsLabel,
          self.topicCollectionView,
          self.activityIndicatorView,
          self.latestFromTheBlogLabel,
          self.blogCollectionView
        )
      )
    )
  }

  override func setConstraints() {
    super.setConstraints()

    self.titleLabel.snp.makeConstraints { (make: ConstraintMaker) in
      make.top.equalTo(self.view.safeAreaLayoutGuide).offset(30)
      make.left.equalToSuperview().inset(15)
    }

    self.scrollView.snp.makeConstraints { (make: ConstraintMaker) in
      make.top.equalTo(self.titleLabel.snp.bottom).offset(20)
      make.left.right.bottom.equalTo(self.view.safeAreaLayoutGuide)
    }

    self.containerView.snp.makeConstraints { (make: ConstraintMaker) in
      make.edges.equalToSuperview()
      make.width.equalTo(self.scrollView.frameLayoutGuide)
    }

    self.uploadPhotoView.snp.makeConstraints { (make: ConstraintMaker) in
      make.top.equalToSuperview()
      make.left.right.equalToSuperview().inset(15)
    }

    self.submitToTopicsLabel.snp.makeConstraints { (make: ConstraintMaker) in
      make.top.equalTo(self.uploadPhotoView.snp.bottom).offset(35)
      make.left.equalToSuperview().inset(15)
    }

    self.topicCollectionView.snp.makeConstraints { (make: ConstraintMaker) in
      make.top.equalTo(self.submitToTopicsLabel.snp.bottom).offset(10)
      make.left.equalToSuperview().inset(10)
      make.right.equalToSuperview()
      make.height.equalTo(240)
    }

    self.activityIndicatorView.snp.makeConstraints { (make: ConstraintMaker) in
      make.edges.equalTo(self.topicCollectionView)
    }

    self.latestFromTheBlogLabel.snp.makeConstraints { (make: ConstraintMaker) in
      make.top.equalTo(self.topicCollectionView.snp.bottom).offset(30)
      make.left.equalToSuperview().inset(10)
    }

    self.blogCollectionView.snp.makeConstraints { (make: ConstraintMaker) in
      make.top.equalTo(self.latestFromTheBlogLabel.snp.bottom).offset(15)
      make.left.equalToSuperview().inset(10)
      make.right.bottom.equalToSuperview()
      make.height.equalTo(215)
    }
  }


  // MARK: - Bind

  override func bind() {
    super.bind()

    let outputs: ContributeViewModel.Outputs = self.viewModel.transform(inputs: .init(
      requestBlogs: self.rx
        .viewDidLoad
        .asObservable(),
      requestTopics: self.rx
        .viewDidLoad
        .asObservable(),
      uploadPhoto: self.uploadPhotoView.rx
        .tapGesture()
        .when(.recognized)
        .throttle(.milliseconds(500), scheduler: MainScheduler.instance)
        .map { _ in }
    ))

    outputs.blogSections
      .drive(self.blogCollectionView.rx.items(dataSource: self.blogDataSource))
      .disposed(by: self.disposeBag)

    outputs.isLoadingTopics
      .drive(self.activityIndicatorView.rx.isAnimating)
      .disposed(by: self.disposeBag)

    outputs.presentAlert
      .drive(self.rx.presentAlert)
      .disposed(by: self.disposeBag)

    outputs.presentNotAuthorizedAlert
      .drive(self.rx.presentObservableBooleanAlert)
      .disposed(by: self.disposeBag)

    outputs.presentImagePicker
      .observeOn(MainScheduler.instance)
      .flatMapLatest { [weak self] _ -> Observable<[UIImagePickerController.InfoKey: AnyObject]> in
        return self?.rx.presentImagePicker ?? .empty()
      }
      .bind(to: self.rx.presentSubmitPhoto)
      .disposed(by: self.disposeBag)

    outputs.topicSections
      .drive(self.topicCollectionView.rx.items(dataSource: self.topicDataSource))
      .disposed(by: self.disposeBag)

    self.blogCollectionView.rx
      .modelSelected(Blog.self)
      .map { (blog: Blog) -> URL in return blog.url }
      .subscribe(onNext: { (url: URL) in
        WindowRouter.tabBarController?.pushWebView(for: url, title: "Unsplash Blog")
      })
      .disposed(by: self.disposeBag)

    self.topicCollectionView.rx
      .modelSelected(Topic.self)
      .bind(to: self.rx.presentSubmitSheet)
      .disposed(by: self.disposeBag)
  }
}


// MARK: - Reactive

extension Reactive where Base: ContributeViewController {

  var presentSubmitPhoto: Binder<[UIImagePickerController.InfoKey: AnyObject]> {
    return Binder(self.base) { (
      base: ContributeViewController,
      info: [UIImagePickerController.InfoKey: AnyObject]
    ) in
      let viewController: SubmitPhotoViewController = AppAssembler.resolve(
        SubmitPhotoViewController.self,
        argument: info
      )

      base.presentedViewController?.present(viewController, animated: true)
    }
  }

  var presentSubmitSheet: Binder<Topic> {
    return Binder(self.base) { (base: ContributeViewController, topic: Topic) in
      let viewController: SubmitSheetViewController = AppAssembler.resolve(
        SubmitSheetViewController.self,
        argument: topic
      )

      viewController.modalPresentationStyle = .custom
      viewController.transitioningDelegate = base.sheetTransitionController

      base.present(viewController, animated: true)
    }
  }
}
