//
//  HomeViewController.swift
//  Unsplash
//
//  Created by 안재영 on 2022/12/28.
//

import PagingKit
import RxCocoa
import RxGesture
import RxSwift
import SnapKit
import UIKit


final class HomeViewController: BaseViewController {

  // MARK: - UI Components

  private let appImageView: BaseImageView = {
    let image: UIImage? = .init(named: "navigation_icon")
    let view: BaseImageView = .init(image: image)
    view.contentMode = .scaleAspectFit
    return view
  }()

  private let topGradientView: GradientView = {
    let view: GradientView = .init()
    view.gradientLayer.locations = [0.3, 0.7, 1.0]
    view.gradientLayer.colors = [
      UIColor.black.withAlphaComponent(1.0).cgColor,
      UIColor.black.withAlphaComponent(0.3).cgColor,
      UIColor.black.withAlphaComponent(0.0).cgColor
    ]
    return view
  }()

  private let focusView: UnderlineFocusView = {
    let view: UnderlineFocusView = .init()
    view.underlineColor = .white
    view.underlineHeight = 2
    return view
  }()

  private let focusBackgroundView: UIView = {
    let view: UIView = .init()
    view.backgroundColor = .lightGray.withAlphaComponent(0.5)
    return view
  }()


  // MARK: - Properties

  private let contentViewController: PagingContentViewController = .init()

  private let menuViewController: PagingMenuViewController = .init()

  private var pagingDataSource: TopicPagingDataSource?

  private let viewModel: HomeViewModel


  // MARK: - Initializers

  init(viewModel: HomeViewModel) {
    self.viewModel = viewModel

    super.init()
  }

  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }


  // MARK: - Life Cycle

  override func viewDidLoad() {
    super.viewDidLoad()

    self.setPagingKit()
  }


  // MARK: - Layout

  override func addSubviews() {
    super.addSubviews()

    self.view.add(
      self.contentViewController.view,
      self.topGradientView,
      self.menuViewController.view,
      self.focusBackgroundView
    )
  }

  override func setConstraints() {
    super.setConstraints()

    self.contentViewController.view.snp.makeConstraints { (make: ConstraintMaker) in
      make.top.left.right.equalToSuperview()
      make.bottom.equalTo(self.view.safeAreaLayoutGuide)
    }

    self.topGradientView.snp.makeConstraints { (make: ConstraintMaker) in
      make.top.left.right.equalToSuperview()
      make.bottom.equalTo(self.menuViewController.view)
    }

    self.menuViewController.view.snp.makeConstraints { (make: ConstraintMaker) in
      make.top.equalTo(self.view.safeAreaLayoutGuide)
      make.left.right.equalToSuperview()
      make.height.equalTo(40)
    }

    self.focusBackgroundView.snp.makeConstraints { (make: ConstraintMaker) in
      make.bottom.equalTo(self.contentViewController.view.snp.top)
      make.left.right.equalToSuperview()
      make.height.equalTo(2)
    }
  }

  override func setNavigationBar() {
    super.setNavigationBar()

    self.navigationItem.setTitleView(
      title: "Unsplash",
      titleFont: .pretendard.bold(20),
      titleColor: .white
    )
    self.navigationItem.leftBarButtonItem = .init(customView: self.appImageView)
  }


  // MARK: - Bind

  override func bind() {
    super.bind()

    let outputs: HomeViewModel.Outputs = self.viewModel.transform(inputs: .init(
      requestTopics: self.rx
        .viewDidLoad
        .asObservable()
    ))

    outputs.presentAlert
      .drive(self.rx.presentAlert)
      .disposed(by: self.disposeBag)

    outputs.presentOnboarding
      .drive(self.rx.presentOnboarding)
      .disposed(by: self.disposeBag)

    outputs.pagingDataSource
      .drive(onNext: { [weak self] (dataSource: TopicPagingDataSource) in
        self?.pagingDataSource = dataSource
        self?.contentViewController.reloadData()
        self?.menuViewController.reloadData()
      })
      .disposed(by: self.disposeBag)

    self.appImageView.rx
      .tapGesture()
      .when(.recognized)
      .map { _ in }
      .bind(to: self.rx.presentAppMenu)
      .disposed(by: self.disposeBag)
  }


  // MARK: - Methods (Private)

  private func setPagingKit() {
    self.menuViewController.register(
      type: PagingMenuCell.self,
      forCellWithReuseIdentifier: "PagingMenuCell"
    )
    self.menuViewController.registerFocusView(view: self.focusView)
    self.menuViewController.cellAlignment = .center
    self.menuViewController.cellSpacing = 5
    self.menuViewController.dataSource = self
    self.menuViewController.delegate = self

    self.contentViewController.dataSource = self
    self.contentViewController.delegate = self
  }
}


// MARK: - PagingMenuViewControllerDelegate

extension HomeViewController: PagingMenuViewControllerDelegate {

  func menuViewController(
    viewController: PagingMenuViewController,
    didSelect page: Int,
    previousPage: Int
  ) {
    self.contentViewController.scroll(to: page, animated: true)
  }
}


// MARK: - PagingMenuViewControllerDataSource

extension HomeViewController: PagingMenuViewControllerDataSource {

  func menuViewController(
    viewController: PagingKit.PagingMenuViewController,
    cellForItemAt index: Int
  ) -> PagingKit.PagingMenuViewCell {
    guard let topics: [Topic] = self.pagingDataSource?.topics,
          let cell: PagingMenuCell = viewController.dequeueReusableCell(
      withReuseIdentifier: "PagingMenuCell",
      for: index
    ) as? PagingMenuCell else {
      return .init()
    }
    cell.title = topics[index].title
    return cell
  }

  func menuViewController(
    viewController: PagingKit.PagingMenuViewController,
    widthForItemAt index: Int
  ) -> CGFloat {
    guard let topics: [Topic] = self.pagingDataSource?.topics else { return 0 }
    let label: UILabel = .init()
    label.text = topics[index].title
    label.sizeToFit()
    return label.frame.width
  }

  func numberOfItemsForMenuViewController(viewController: PagingKit.PagingMenuViewController) -> Int {
    return self.pagingDataSource?.topics.count ?? 0
  }
}


// MARK: - PagingContentViewControllerDelegate

extension HomeViewController: PagingContentViewControllerDelegate {

  func contentViewController(
    viewController: PagingContentViewController,
    didManualScrollOn index: Int,
    percent: CGFloat
  ) {
    self.menuViewController.scroll(index: index, animated: true)
  }
}


// MARK: - PagingContentViewControllerDataSource

extension HomeViewController: PagingContentViewControllerDataSource {

  func numberOfItemsForContentViewController(viewController: PagingContentViewController) -> Int {
    return self.pagingDataSource?.topics.count ?? 0
  }

  func contentViewController(
    viewController: PagingContentViewController,
    viewControllerAt index: Int
  ) -> UIViewController {
    return self.pagingDataSource?.topicViewControllers[index] ?? .init()
  }
}


// MARK: - Reactive

extension Reactive where Base: HomeViewController {

  var presentAppMenu: Binder<Void> {
    return Binder(self.base) { (base: HomeViewController, _) in
      let viewController: AppMenuViewController = AppAssembler.resolve(AppMenuViewController.self)

      base.present(viewController, animated: true)
    }
  }

  var presentOnboarding: Binder<Void> {
    return Binder(self.base) { (base: HomeViewController, _) in
      let viewController: OnboardingViewController = AppAssembler.resolve(OnboardingViewController.self)
      
      base.present(viewController, animated: true)
    }
  }
}
