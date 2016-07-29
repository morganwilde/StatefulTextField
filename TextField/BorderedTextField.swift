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
  
  var borders = [BorderLocation: CALayer]()
}

// MARK: Sizing

extension BorderedTextField {
  override func layoutSublayersOfLayer(layer: CALayer) {
//    animatingLayer.frame = bounds
  }
}
