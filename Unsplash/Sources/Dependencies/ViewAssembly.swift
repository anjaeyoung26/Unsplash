//
//  ViewAssembly.swift
//  Unsplash
//
//  Created by 안재영 on 2023/01/22.
//

import Swinject


final class ViewAssembly: Assembly {

  // MARK: - Methods

  func assemble(container: Container) {
    container.register(RecentSearchView.self, factory: { (
      resolver: Resolver
    ) -> RecentSearchView in
      return .init(viewModel: resolver.resolve(RecentSearchViewModel.self)!)
    })

    container.register(SearchResultView.self, factory: { (
      resolver: Resolver
    ) -> SearchResultView in
      return .init(viewModel: resolver.resolve(SearchResultViewModel.self)!)
    })
  }
}
