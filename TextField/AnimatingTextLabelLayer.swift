//
//  AnimatingTextLabelLayer.swift
//  TextField
//
//  Created by Morgan Wilde on 7/27/16.
//  Copyright © 2016 Morgan Wilde. All rights reserved.
//

import UIKit

class AnimatingTextLabelLayer: CALayer {
  
  var text: String
  var fontSize: CGFloat = AnimatingTextLabel.defaultFontSize
  var fontWeight: CGFloat!
  var textBackgroundColor: UIColor!
  var textForegroundColor: UIColor!
  
  var attributedString: NSAttributedString {
    return getAttributedStringWithFontSize(fontSize)
  }
  var textSize: CGSize {
    return getTextSizeWithFontSize(fontSize)
  }
  
  // Variable getters
  func getAttributedStringWithFontSize(fontSize: CGFloat) -> NSAttributedString {
    let attributes = [
      NSFontAttributeName: UIFont.systemFontOfSize(fontSize, weight: fontWeight),
      NSBackgroundColorAttributeName: textBackgroundColor,
      NSForegroundColorAttributeName: textForegroundColor,
    ]
    return NSAttributedString(string: text, attributes: attributes)
  }
  func getTextSizeWithFontSize(fontSize: CGFloat) -> CGSize {
    return getAttributedStringWithFontSize(fontSize).size()
  }
  
  // Initializers
  init(text: String) {
    self.text = text
    super.init()
    setNeedsDisplay()
    contentsScale = UIScreen.mainScreen().scale
  }
  override init(layer: AnyObject) {
    if let layer = layer as? AnimatingTextLabelLayer {
      text = layer.text
      fontSize = layer.fontSize
      fontWeight = layer.fontWeight
      textBackgroundColor = layer.textBackgroundColor
      textForegroundColor = layer.textForegroundColor
    } else {
      text = ""
    }
    super.init(layer: layer)
  }
  required init?(coder aDecoder: NSCoder) {
    return nil
  }
  
  // Drawing
  override class func needsDisplayForKey(key: String) -> Bool {
    switch key {
      case "fontSize": return true
      default: return super.needsDisplayForKey(key)
    }
  }
  override func actionForKey(event: String) -> CAAction? {
    switch event {
      case "contents": fallthrough
      case "bounds": fallthrough
      case "position": return nil
      default: return super.actionForKey(event)
    }
  }
  override func drawInContext(ctx: CGContext) {
    let rect = CGContextGetClipBoundingBox(ctx)
    let attributedString = self.attributedString
    
    UIGraphicsPushContext(ctx)
//    attributedString.drawAtPoint(rect.origin)
    attributedString.drawAtPoint(CGPoint(
      x: 0,
      y: rect.origin.y + rect.height/2 - attributedString.size().height/2)
    )
    UIGraphicsPopContext()
  }
}