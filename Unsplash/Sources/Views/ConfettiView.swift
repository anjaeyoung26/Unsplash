//
//  ConfettiView.swift
//  Unsplash
//
//  Created by 안재영 on 2023/01/12.
//

import QuartzCore
import UIKit


final class ConfettiView: UIView {

  // MARK: - Properties

  var colors: [UIColor] = [
    .init(red: 0.95, green: 0.40, blue: 0.27, alpha: 1.0),
    .init(red: 1.00, green: 0.78, blue: 0.36, alpha: 1.0),
    .init(red: 0.48, green: 0.78, blue: 0.64, alpha: 1.0),
    .init(red: 0.30, green: 0.76, blue: 0.85, alpha: 1.0),
    .init(red: 0.58, green: 0.39, blue: 0.55, alpha: 1.0)
  ]

  private var emitter: CAEmitterLayer!

  var isActive: Bool = false


  // MARK: - Methods

  func start() {
    self.emitter = CAEmitterLayer()
    self.emitter.beginTime = CACurrentMediaTime()
    self.emitter.emitterShape = .line
    self.emitter.emitterSize = .init(width: self.frame.size.width, height: 1)
    self.emitter.emitterPosition = .init(x: self.frame.size.width / 2.0, y: 0)

    var cells: [CAEmitterCell] = []
    for color in self.colors {
      let cell: CAEmitterCell = self.confetti(color: color)
      cells.append(cell)
    }

    self.emitter.emitterCells = cells
    self.isActive = true
    self.layer.addSublayer(self.emitter)
  }

  func stop() {
    self.emitter?.birthRate = 0
    self.isActive = false
  }

  private func confetti(color: UIColor) -> CAEmitterCell {
    let emitterCell: CAEmitterCell = .init()
    emitterCell.contents = UIImage(named: "confetti_image")?.cgImage
    emitterCell.color = color.cgColor
    emitterCell.birthRate = 1.3
    emitterCell.lifetime = 7.0
    emitterCell.lifetimeRange = 0
    emitterCell.velocity = 100
    emitterCell.velocityRange = 50
    emitterCell.emissionRange = CGFloat.pi / 4
    emitterCell.emissionLongitude = CGFloat.pi
    emitterCell.spin = 2
    emitterCell.spinRange = 3
    emitterCell.scaleRange = 0.5
    emitterCell.scaleSpeed = -0.05
    return emitterCell
  }
}
