//
//  TabBarController.swift
//  Unsplash
//
//  Created by 안재영 on 2022/12/28.
//

import RxCocoa
import RxSwift
import UIKit


final class TabBarController: BaseTabBarController {

  // MARK: - UI Components

  private let homeTabBarItem: UITabBarItem = {
    let item: UITabBarItem = .init(
      title: nil,
      image: .init(named: "un_home_icon"),
      selectedImage: .init(named: "home_icon")
    )
    return item
  }()

  private let searchTabBarItem: UITabBarItem = {
    let item: UITabBarItem = .init(
      title: nil,
      image: .init(named: "un_search_icon"),
      selectedImage: .init(named: "search_icon")
    )
    return item
  }()

  private let contributeTabBarItem: UITabBarItem = {
    let item: UITabBarItem = .init(
      title: nil,
      image: .init(named: "un_contribute_icon"),
      selectedImage: .init(named: "contribute_icon")
    )
    return item
  }()

  private let profileTabBarItem: UITabBarItem = {
    let item: UITabBarItem = .init(
      title: nil,
      image: .init(named: "un_profile_icon"),
      selectedImage: .init(named: "profile_icon")
    )
    return item
  }()


  // MARK: - Properties

  private var homeViewController: HomeViewController!

  private var searchViewController: SearchViewController!

  private var contributeViewController: ContributeViewController!

  private var profileViewController: ProfileViewController!


  // MARK: - Initializers

  override init() {
    super.init()

    self.tabBar.items?.forEach { (item: UITabBarItem) in item.imageInsets.bottom = -15 }
  }

  required init(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented.")
  }


  // MARK: - Layout

  override func setViewControllers() {
    super.setViewControllers()

    self.homeViewController = AppAssembler.resolve(HomeViewController.self)
    self.homeViewController.tabBarItem = self.homeTabBarItem

    self.searchViewController = AppAssembler.resolve(SearchViewController.self)
    self.searchViewController.tabBarItem = self.searchTabBarItem

    self.contributeViewController = AppAssembler.resolve(ContributeViewController.self)
    self.contributeViewController.tabBarItem = self.contributeTabBarItem

    self.profileViewController = AppAssembler.resolve(ProfileViewController.self, argument: User.me)
    self.profileViewController.tabBarItem = self.profileTabBarItem

    self.viewControllers = [
      UINavigationController(rootViewController: self.homeViewController),
      UINavigationController(rootViewController: self.searchViewController),
      UINavigationController(rootViewController: self.contributeViewController),
      UINavigationController(rootViewController: self.profileViewController)
    ]
  }


  // MARK: - Bind

  override func bind() {
    super.bind()

    Observable<Bool>
      .merge(
        self.homeViewController.rx.isVisible,
        self.searchViewController.rx.isVisible,
        self.contributeViewController.rx.isVisible,
        self.profileViewController.rx.isVisible
      )
      .filter { (isVisible: Bool) -> Bool in return isVisible }
      .subscribe(onNext: { [weak self] _ in self?.showTabBarIfNeeded(animated: true) })
      .disposed(by: self.disposeBag)
  }


  // MARK: - Methods

  func pushSearchKeyword(for keyword: String) {
    let viewController: SearchKeywordViewController = AppAssembler.resolve(
      SearchKeywordViewController.self,
      argument: keyword
    )

    self.pushViewController(viewController)
  }

  func pushCollectionPhoto(for collection: Collection) {
    let viewController: CollectionPhotoViewController = AppAssembler.resolve(
      CollectionPhotoViewController.self,
      argument: collection
    )

    self.pushViewController(viewController)
  }

  func pushDetailPhoto(for photo: Photo) {
    let viewController: DetailPhotoViewController = AppAssembler.resolve(
      DetailPhotoViewController.self,
      argument: photo
    )

    self.pushViewController(viewController)
  }

  func pushProfile(for user: User?) {
    let viewController: ProfileViewController = AppAssembler.resolve(
      ProfileViewController.self,
      argument: user
    )

    self.pushViewController(viewController)
  }

  func pushMyStat() {
    let viewController: StatViewController = AppAssembler.resolve(StatViewController.self)

    self.pushViewController(viewController, hideTabBar: false)
  }

  func pushWebView(for url: URL, title: String) {
    let viewController: WebViewController = .init(url: url)
    viewController.title = title

    self.pushViewController(viewController)
  }

  func presentAccountSettings() {
    let viewController: AccountSettingsViewController = AppAssembler.resolve(AccountSettingsViewController.self)
    let navigationController: UINavigationController = .init(rootViewController: viewController)
    
    self.present(navigationController, animated: true)
  }

  func presentThanksSubmit(for photo: Photo) {
    let viewController: ThanksSubmitViewController = AppAssembler.resolve(
      ThanksSubmitViewController.self,
      argument: photo
    )

    self.present(viewController, animated: true)
  }


  // MARK: - Methods (Private)

  private func pushViewController(
    _ viewController: UIViewController,
    animated: Bool = true,
    hideTabBar: Bool = true
  ) {
    self.selectedNavigationController?.pushViewController(viewController, animated: animated)

    if hideTabBar {
      self.hideTabBarIfNeeded(animated: animated)
    }
  }
}
