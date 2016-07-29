//
//  ToggleableTextLabel.swift
//  TextField
//
//  Created by Morgan Wilde on 7/27/16.
//  Copyright © 2016 Morgan Wilde. All rights reserved.
//

import UIKit

class ToggleableTextLabel: AnimatingTextLabel {
  
  enum State {
    case Small
    case Big
  }
  
  static let defaultToggleDuration: CFTimeInterval = 0.5
  
  var fontSizeFrom: CGFloat
  var fontSizeTo: CGFloat
  
  func getSizeForState(state: State) -> CGSize {
    let sizes: (small: CGFloat, big: CGFloat) = fontSizeFrom < fontSizeTo ? (fontSizeFrom, fontSizeTo) : (fontSizeTo, fontSizeFrom)
    switch state {
      case .Small: return getTextSizeWithFontSize(sizes.small)
      case .Big: return getTextSizeWithFontSize(sizes.big)
    }
  }
  
  init(text: String, toggleFontSizeFrom sizeFrom: CGFloat, to sizeTo: CGFloat) {
    fontSizeFrom = sizeFrom
    fontSizeTo = sizeTo
    
    super.init(text: text)
    
    fontSize = fontSizeFrom
  }
  required init?(coder aDecoder: NSCoder) {
    return nil
  }
}

extension ToggleableTextLabel {
  func toggleWithDuration(duration: CFTimeInterval, callback: (() -> ())? = nil) {
    let target = fontSize == fontSizeFrom ? fontSizeTo : fontSizeFrom
    animateFontSizeTo(target, withDuration: duration, callback: callback)
  }
  func toggleWithCallback(callback: () -> ()) {
    toggleWithDuration(ToggleableTextLabel.defaultToggleDuration, callback: callback)
  }
  func toggle() {
    toggleWithDuration(ToggleableTextLabel.defaultToggleDuration, callback: nil)
  }
}