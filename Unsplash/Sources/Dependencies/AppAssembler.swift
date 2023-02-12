//
//  AppAssembler.swift
//  Unsplash
//
//  Created by 안재영 on 2023/01/01.
//

import Swinject


final class AppAssembler {

  // MARK: - Properties

  private static let assembler: Assembler = .init([
    ServiceAssembly(),
    ViewControllerAssembly(),
    ViewModelAssembly(),
    ViewAssembly()
  ])


  // MARK: - Methods

  static func resolve<Service>(_ serviceType: Service.Type) -> Service {
    return self.assembler.resolver.resolve(serviceType)!
  }

  static func resolve<Service, Arg1>(_ serviceType: Service.Type, argument: Arg1) -> Service {
    return self.assembler.resolver.resolve(serviceType, argument: argument)!
  }
}
