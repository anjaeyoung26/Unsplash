//
//  UITableView+.swift
//  Unsplash
//
//  Created by 안재영 on 2023/01/01.
//

import UIKit


extension UITableView {

  func register<Cell: ReusableType>(_ cell: Cell.Type) {
    self.register(cell.classType, forCellReuseIdentifier: cell.identifier)
  }

  func dequeue<Cell: UITableViewCell & ReusableType>(
    _ cell: Cell.Type,
    for indexPath: IndexPath
  ) -> Cell {
    return self.dequeueReusableCell(
      withIdentifier: cell.identifier,
      for: indexPath
    ) as? Cell ?? .init()
  }
}
