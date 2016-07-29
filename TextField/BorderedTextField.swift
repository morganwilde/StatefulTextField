//
//  BorderedTextField.swift
//  TextField
//
//  Created by Morgan Wilde on 7/29/16.
//  Copyright © 2016 Morgan Wilde. All rights reserved.
//

import UIKit

class BorderedTextField: UITextField {

  enum BorderLocation {
    case Top
    case Right
    case Bottom
    case Left
  }
  
  static let defaultColor = aluminumColor
  static let defaultBorderWeight: CGFloat = 0.5
  
  var borderWeight = BorderedTextField.defaultBorderWeight
  var borders = [BorderLocation]() {
    didSet {
      for (borderLocation, _) in borderLayers {
        if borders.contains(borderLocation) {
          let borderLayer = CALayer()
          borderLayer.backgroundColor = BorderedTextField.defaultColor.CGColor
          layer.addSublayer(borderLayer)
          borderLayers[borderLocation] = borderLayer
        } else {
          borderLayers[borderLocation]??.removeFromSuperlayer()
          borderLayers[borderLocation] = nil
        }
      }
    }
  }
  var borderLayers: [BorderLocation: CALayer?] = [
    .Top: nil,
    .Right: nil,
    .Bottom: nil,
    .Left: nil,
  ]
  
  init() {
    super.init(frame: CGRect())
   
    returnKeyType = .Done
    translatesAutoresizingMaskIntoConstraints = false
  }
  required init?(coder aDecoder: NSCoder) {
    return nil
  }
}

// MARK: Sizing

extension BorderedTextField {
  override func layoutSublayersOfLayer(layer: CALayer) {
    for (borderLocation, borderLayer) in borderLayers {
      if let borderLayer = borderLayer {
        switch borderLocation {
          case .Top: borderLayer.frame = CGRect(x: 0, y: 0, width: bounds.width, height: borderWeight)
          case .Right: borderLayer.frame = CGRect(x: bounds.width - borderWeight, y: 0, width: borderWeight, height: bounds.height)
          case .Bottom: borderLayer.frame = CGRect(x: 0, y: bounds.height - borderWeight, width: bounds.width, height: borderWeight)
          case .Left: borderLayer.frame = CGRect(x: 0, y: 0, width: borderWeight, height: bounds.height)
        }
      }
    }
    super.layoutSublayersOfLayer(layer)
  }
}
