//
//  ViewModelType.swift
//  Unsplash
//
//  Created by ėėŽė on 2022/12/28.
//

protocol ViewModelType {

  // MARK: - Defines

  associatedtype Inputs

  associatedtype Outputs


  // MARK: - Methods

  func transform(inputs: Inputs) -> Outputs
}
