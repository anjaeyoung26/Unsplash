//
//  ChartMarkerView.swift
//  Unsplash
//
//  Created by 안재영 on 2023/02/03.
//

import Charts
import Foundation
import UIKit


final class ChartMarkerView: MarkerImage {

  // MARK: - Properties

  var insets: UIEdgeInsets = .init(top: 10, left: 10, bottom: 10, right: 10)

  var cornerRadius: CGFloat = 7

  var backgroundColor: UIColor = .darkGray

  private var attributeString: NSMutableAttributedString?


  // MARK: - Methods

  override func offsetForDrawing(atPoint point: CGPoint) -> CGPoint {
    var offset: CGPoint = self.offset
    var size: CGSize = self.size

    if size.width == 0.0 && self.image != nil {
      size.width = self.image!.size.width
    }

    if size.height == 0.0 && self.image != nil {
      size.height = self.image!.size.height
    }

    let width: CGFloat = size.width
    let height: CGFloat = size.height
    let padding: CGFloat = 8.0

    var origin: CGPoint = point
    origin.x -= width / 2
    origin.y -= height

    if origin.x + offset.x < 0.0 {
      offset.x = -origin.x + padding
    } else if let chart = self.chartView, origin.x + width + offset.x > chart.bounds.size.width {
      offset.x = chart.bounds.size.width - origin.x - width - padding
    }

    if origin.y + offset.y < 0 {
      offset.y = height + padding;
    } else if let chart = self.chartView, origin.y + height + offset.y > chart.bounds.size.height {
      offset.y = chart.bounds.size.height - origin.y - height - padding
    }

    return offset
  }

  override func draw(context: CGContext, point: CGPoint) {
    guard let chartView: ChartViewBase = self.chartView,
          let attributeString: NSMutableAttributedString = self.attributeString else { return }

    let offset: CGPoint = self.offsetForDrawing(atPoint: point)
    let size: CGSize = self.size
    let origin: CGPoint = .init(
      x: point.x + offset.x - (size.width / 2.0),
      y: chartView.bounds.minY
    )

    var rect: CGRect = .init(origin: origin, size: size)

    context.saveGState()
    context.setFillColor(self.backgroundColor.cgColor)

    context.beginPath()
    let bezierPath: UIBezierPath = .init(roundedRect: rect, cornerRadius: self.cornerRadius)
    context.addPath(bezierPath.cgPath)
    context.closePath()
    context.fillPath()

    if offset.y > 0 {
      context.beginPath()
      let point1: CGPoint = .init(
        x: rect.origin.x + rect.size.width / 2.0,
        y: rect.origin.y + 1
      )
      context.move(to: point1)
      context.addLine(to: CGPoint(x: point1.x, y: point1.y))
      context.addLine(to: CGPoint(x: point.x, y: point.y))
      context.addLine(to: point1)
      context.fillPath()

    } else {
      context.beginPath()
      let point2: CGPoint = .init(
        x: rect.origin.x + rect.size.width / 2.0,
        y: rect.origin.y + rect.size.height - 1
      )
      context.move(to: point2)
      context.addLine(to: CGPoint(x: point2.x, y: point2.y))
      context.addLine(to: CGPoint(x: point.x, y: point.y))
      context.addLine(to: point2)
      context.fillPath()
    }

    rect.origin.y += self.insets.top
    rect.size.height -= self.insets.top + self.insets.bottom

    UIGraphicsPushContext(context)
    attributeString.draw(in: rect)
    UIGraphicsPopContext()
    context.restoreGState()
  }

  func setText(_ text: NSMutableAttributedString) {
    self.attributeString = text

    var size: CGSize = .init()
    size.width = text.size().width + self.insets.left + self.insets.right
    size.height = text.size().height + self.insets.top + self.insets.bottom
    self.size = size
  }
}

