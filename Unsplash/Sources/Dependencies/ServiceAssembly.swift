//
//  ServiceAssembly.swift
//  Unsplash
//
//  Created by 안재영 on 2023/01/01.
//

import Moya
import Swinject


final class ServiceAssembly: Assembly {

  // MARK: - Methods

  func assemble(container: Container) {
    container.register(CollectionServiceType.self, factory: { (
      resolver: Resolver
    ) -> CollectionServiceType in
      let networking: Networking<CollectionAPI> = Self.resolveNetworking(resolver: resolver)
      return CollectionService(networking: networking)
    })

    container.register(KeychainServiceType.self, factory: { _ -> KeychainServiceType in
      return KeychainService(keychain: .init(service: "ajy.unsplash.clone"))
    })

    container.register(OAuthServiceType.self, factory: { (
      resolver: Resolver
    ) -> OAuthServiceType in
      let networking: Networking<OAuthAPI> = Self.resolveNetworking(resolver: resolver)
      return OAuthService(networking: networking)
    })

    container.register(PhotoServiceType.self, factory: { (
      resolver: Resolver
    ) -> PhotoServiceType in
      let networking: Networking<PhotoAPI> = Self.resolveNetworking(resolver: resolver)
      return PhotoService(networking: networking)
    })

    container.register(TopicServiceType.self, factory: { (
      resolver: Resolver
    ) -> TopicServiceType in
      let networking: Networking<TopicAPI> = Self.resolveNetworking(resolver: resolver)
      return TopicService(networking: networking)
    })

    container.register(UserServiceType.self, factory: { (
      resolver: Resolver
    ) -> UserServiceType in
      let networking: Networking<UserAPI> = Self.resolveNetworking(resolver: resolver)
      return UserService(networking: networking)
    })
  }


  // MARK: - Methods (Private)

  private static func resolveNetworking<T: TargetType>(resolver: Resolver) -> Networking<T> {
    return .init(
      stubClosure: Networking<T>.neverStub,
      plugins: [
        AuthorizationPlugin(keychainService: resolver.resolve(KeychainServiceType.self)!),
        LoggingPlugin()
      ]
    )
  }
}
