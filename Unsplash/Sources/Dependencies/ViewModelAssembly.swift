//
//  ViewModelAssembly.swift
//  Unsplash
//
//  Created by 안재영 on 2023/01/01.
//

import Swinject


final class ViewModelAssembly: Assembly {

  // MARK: - Methods

  func assemble(container: Container) {
    container.register(AccountSettingViewModel.self, factory: { (
      resolver: Resolver
    ) -> AccountSettingViewModel in
      return .init(userService: resolver.resolve(UserServiceType.self)!)
    })

    container.register(AddToCollectionViewModel.self, factory: { (
      resolver: Resolver
    ) -> AddToCollectionViewModel in
      return .init(
        collectionService: resolver.resolve(CollectionServiceType.self)!,
        userService: resolver.resolve(UserServiceType.self)!
      )
    })

    container.register(AppMenuViewModel.self, factory: { (
      resolver: Resolver
    ) -> AppMenuViewModel in
      return .init()
    })

    container.register(CollectionPhotoViewModel.self, factory: { (
      resolver: Resolver
    ) -> CollectionPhotoViewModel in
      return .init(collectionService: resolver.resolve(CollectionServiceType.self)!)
    })

    container.register(ContributeViewModel.self, factory: { (
      resolver: Resolver
    ) -> ContributeViewModel in
      return .init(topicService: resolver.resolve(TopicServiceType.self)!)
    })

    container.register(EditCollectionViewModel.self, factory: { (
      resolver: Resolver
    ) -> EditCollectionViewModel in
      return .init(collectionService: resolver.resolve(CollectionServiceType.self)!)
    })

    container.register(EditLocationViewModel.self, factory: { (
      resolver: Resolver
    ) -> EditLocationViewModel in
      return .init()
    })

    container.register(DetailPhotoViewModel.self, factory: { (
      resolver: Resolver
    ) -> DetailPhotoViewModel in
      return .init(photoService: resolver.resolve(PhotoServiceType.self)!)
    })

    container.register(EditProfileViewModel.self, factory: { (
      resolver: Resolver
    ) -> EditProfileViewModel in
      return .init(userService: resolver.resolve(UserServiceType.self)!)
    })

    container.register(HomeViewModel.self, factory: { (
      resolver: Resolver
    ) -> HomeViewModel in
      return .init(topicService: resolver.resolve(TopicServiceType.self)!)
    })

    container.register(InfoPhotoViewModel.self, factory: { (
      resolver: Resolver
    ) -> InfoPhotoViewModel in
      return .init()
    })

    container.register(LoginViewModel.self, factory: { (
      resolver: Resolver
    ) -> LoginViewModel in
      return .init(
        authService: resolver.resolve(OAuthServiceType.self)!,
        keychainService: resolver.resolve(KeychainServiceType.self)!,
        userService: resolver.resolve(UserServiceType.self)!
      )
    })

    container.register(OnboardingViewModel.self, factory: { (
      resolver: Resolver
    ) -> OnboardingViewModel in
      return .init(photoService: resolver.resolve(PhotoServiceType.self)!)
    })

    container.register(ProfileViewModel.self, factory: { (
      resolver: Resolver
    ) -> ProfileViewModel in
      return .init(
        keychainService: resolver.resolve(KeychainServiceType.self)!,
        userService: resolver.resolve(UserServiceType.self)!
      )
    })

    container.register(RecentSearchViewModel.self, factory: { (
      resolver: Resolver
    ) -> RecentSearchViewModel in
      return .init()
    })

    container.register(SearchViewModel.self, factory: { (
      resolver: Resolver
    ) -> SearchViewModel in
      return .init(photoService: resolver.resolve(PhotoServiceType.self)!)
    })

    container.register(SearchKeywordViewModel.self, factory: { (
      resolver: Resolver
    ) -> SearchKeywordViewModel in
      return .init(photoService: resolver.resolve(PhotoServiceType.self)!)
    })

    container.register(SearchResultViewModel.self, factory: { (
      resolver: Resolver
    ) -> SearchResultViewModel in
      return .init(photoService: resolver.resolve(PhotoServiceType.self)!)
    })

    container.register(SplashViewModel.self, factory: { (
      resolver: Resolver
    ) -> SplashViewModel in
      return .init(
        keychainService: resolver.resolve(KeychainServiceType.self)!,
        userService: resolver.resolve(UserServiceType.self)!
      )
    })

    container.register(StatViewModel.self, factory: { (
      resolver: Resolver
    ) -> StatViewModel in
      return .init(userService: resolver.resolve(UserServiceType.self)!)
    })

    container.register(SubmitPhotoViewModel.self, factory: { (
      resolver: Resolver
    ) -> SubmitPhotoViewModel in
      return .init(photoService: resolver.resolve(PhotoServiceType.self)!)
    })

    container.register(SubmitSheetViewModel.self, factory: { (
      resolver: Resolver
    ) -> SubmitSheetViewModel in
      return .init(topicService: resolver.resolve(TopicServiceType.self)!)
    })

    container.register(TopicViewModel.self, factory: { (
      resolver: Resolver
    ) -> TopicViewModel in
      return .init(
        photoService: resolver.resolve(PhotoServiceType.self)!,
        topicService: resolver.resolve(TopicServiceType.self)!
      )
    })
  }
}
