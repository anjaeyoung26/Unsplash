//
//  ViewControllerAssembly.swift
//  Unsplash
//
//  Created by 안재영 on 2023/01/08.
//

import Swinject
import UIKit


final class ViewControllerAssembly: Assembly {

  // MARK: - Methods

  func assemble(container: Container) {
    container.register(AccountSettingsViewController.self, factory: { (
      resolver: Resolver
    ) -> AccountSettingsViewController in
      return .init(viewModel: resolver.resolve(AccountSettingViewModel.self)!)
    })

    container.register(AddToCollectionViewController.self, factory: { (
      resolver: Resolver,
      photo: Photo
    ) -> AddToCollectionViewController in
      return .init(
        viewModel: resolver.resolve(AddToCollectionViewModel.self)!,
        photo: photo
      )
    })

    container.register(AppMenuViewController.self, factory: { (
      resolver: Resolver
    ) -> AppMenuViewController in
      return .init(viewModel: resolver.resolve(AppMenuViewModel.self)!)
    })

    container.register(CollectionPhotoViewController.self, factory: { (
      resolver: Resolver,
      collection: Collection
    ) -> CollectionPhotoViewController in
      return .init(
        viewModel: resolver.resolve(CollectionPhotoViewModel.self)!,
        collection: collection
      )
    })

    container.register(ContributeViewController.self, factory: { (
      resolver: Resolver
    ) -> ContributeViewController in
      return .init(viewModel: resolver.resolve(ContributeViewModel.self)!)
    })

    container.register(EditCollectionViewController.self, factory: { (
      resolver: Resolver,
      collection: Collection?
    ) -> EditCollectionViewController in
      return .init(
        viewModel: resolver.resolve(EditCollectionViewModel.self)!,
        collection: collection
      )
    })

    container.register(EditLocationViewController.self, factory: { (
      resolver: Resolver,
      priorLocation: Location?
    ) -> EditLocationViewController in
      return .init(
        viewModel: resolver.resolve(EditLocationViewModel.self)!,
        priorLocation: priorLocation
      )
    })

    container.register(DetailPhotoViewController.self, factory: { (
      resolver: Resolver,
      photo: Photo
    ) -> DetailPhotoViewController in
      return .init(
        viewModel: resolver.resolve(DetailPhotoViewModel.self)!,
        photo: photo
      )
    })

    container.register(EditProfileViewController.self, factory: { (
      resolver: Resolver
    ) -> EditProfileViewController in
      return .init(viewModel: resolver.resolve(EditProfileViewModel.self)!)
    })

    container.register(HomeViewController.self, factory: { (
      resolver: Resolver
    ) -> HomeViewController in
      return .init(viewModel: resolver.resolve(HomeViewModel.self)!)
    })

    container.register(InfoPhotoViewController.self, factory: { (
      resolver: Resolver,
      photo: Photo
    ) -> InfoPhotoViewController in
      return .init(
        viewModel: resolver.resolve(InfoPhotoViewModel.self)!,
        photo: photo
      )
    })

    container.register(LoginViewController.self, factory: { (
      resolver: Resolver
    ) -> LoginViewController in
      return .init(viewModel: resolver.resolve(LoginViewModel.self)!)
    })

    container.register(OnboardingViewController.self, factory: { (
      resolver: Resolver
    ) -> OnboardingViewController in
      return .init(viewModel: resolver.resolve(OnboardingViewModel.self)!)
    })

    container.register(ProfileViewController.self, factory: { (
      resolver: Resolver,
      user: User?
    ) -> ProfileViewController in
      return .init(viewModel: resolver.resolve(ProfileViewModel.self)!, user: user)
    })

    container.register(SearchViewController.self, factory: { (
      resolver: Resolver
    ) -> SearchViewController in
      return .init(viewModel: resolver.resolve(SearchViewModel.self)!)
    })

    container.register(SplashViewController.self, factory: { (
      resolver: Resolver
    ) -> SplashViewController in
      return .init(viewModel: resolver.resolve(SplashViewModel.self)!)
    })

    container.register(SearchKeywordViewController.self, factory: { (
      resolver: Resolver,
      keyword: String
    ) -> SearchKeywordViewController in
      return .init(
        viewModel: resolver.resolve(SearchKeywordViewModel.self)!,
        keyword: keyword
      )
    })

    container.register(StatViewController.self, factory: { (
      resolver: Resolver
    ) -> StatViewController in
      return .init(viewModel: resolver.resolve(StatViewModel.self)!)
    })

    container.register(SubmitPhotoViewController.self, factory: { (
      resolver: Resolver,
      info: [UIImagePickerController.InfoKey: AnyObject]
    ) -> SubmitPhotoViewController in
      return .init(
        viewModel: resolver.resolve(SubmitPhotoViewModel.self)!,
        info: info
      )
    })

    container.register(SubmitSheetViewController.self, factory: { (
      resolver: Resolver,
      topic: Topic
    ) -> SubmitSheetViewController in
      return .init(
        viewModel: resolver.resolve(SubmitSheetViewModel.self)!,
        topic: topic
      )
    })

    container.register(SubmitProgressViewController.self, factory: { (
      resolver: Resolver
    ) -> SubmitProgressViewController in
      return .init()
    })

    container.register(TopicViewController.self, factory: { (
      resolver: Resolver,
      topic: Topic
    ) -> TopicViewController in
      return .init(
        viewModel: resolver.resolve(TopicViewModel.self)!,
        topic: topic
      )
    })

    container.register(ThanksSubmitViewController.self, factory: { (
      resolver: Resolver,
      photo: Photo
    ) -> ThanksSubmitViewController in
      return .init(photo: photo)
    })
  }
}
