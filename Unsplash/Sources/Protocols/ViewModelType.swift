//
//  ViewModelType.swift
//  Unsplash
//
//  Created by 안재영 on 2022/12/28.
//

protocol ViewModelType {

  // MARK: - Defines

  associatedtype Inputs

  associatedtype Outputs


  // MARK: - Methods

  func transform(inputs: Inputs) -> Outputs
}
