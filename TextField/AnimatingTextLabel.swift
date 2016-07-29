//
//  TextLabel.swift
//  TextField
//
//  Created by Morgan Wilde on 7/24/16.
//  Copyright © 2016 Morgan Wilde. All rights reserved.
//

import UIKit

class AnimatingTextLabel: UIView {

  static let defaultFontSize: CGFloat = 20
  static let defaultFontWeight: CGFloat = UIFontWeightRegular
  static let defaultTextBackgroundColor = UIColor.clearColor()
  static let defaultTextForegroundColor = steelColor
  
  var animatingLayer: AnimatingTextLabelLayer!
  var fontSize: CGFloat {
    get { return animatingLayer.fontSize }
    set { animatingLayer.fontSize = newValue }
  }
  var fontWeight: CGFloat {
    get { return animatingLayer.fontWeight }
    set { animatingLayer.fontWeight = newValue }
  }
  var textBackgroundColor: UIColor {
    get { return animatingLayer.textBackgroundColor }
    set { animatingLayer.textBackgroundColor = newValue }
  }
  var textForegroundColor: UIColor {
    get { return animatingLayer.textForegroundColor }
    set { animatingLayer.textForegroundColor = newValue }
  }
  var targetFontSize: CGFloat?
  var targetTextSize: CGSize? {
    if let targetFontSize = targetFontSize {
      return animatingLayer.getTextSizeWithFontSize(targetFontSize)
    }
    return nil
  }
  
  func getTextSizeWithFontSize(fontSize: CGFloat) -> CGSize {
    return animatingLayer.getTextSizeWithFontSize(fontSize)
  }
  
  init(text: String) {
    super.init(frame: CGRect())
    
    translatesAutoresizingMaskIntoConstraints = false
    
    animatingLayer = AnimatingTextLabelLayer(text: text)
    animatingLayer.fontSize = AnimatingTextLabel.defaultFontSize
    animatingLayer.fontWeight = AnimatingTextLabel.defaultFontWeight
    animatingLayer.textBackgroundColor = AnimatingTextLabel.defaultTextBackgroundColor
    animatingLayer.textForegroundColor = AnimatingTextLabel.defaultTextForegroundColor
    
    layer.addSublayer(animatingLayer)
  }
  required init?(coder aDecoder: NSCoder) {
    return nil
  }
}

// MARK: Sizing

extension AnimatingTextLabel {
  override func layoutSublayersOfLayer(layer: CALayer) {
    animatingLayer.frame = bounds
  }
  override func intrinsicContentSize() -> CGSize {
    if let targetTextSize = targetTextSize {
      return targetTextSize
    }
    return animatingLayer.textSize
  }
}

// MARK: Events

extension AnimatingTextLabel {
  func animateFontSizeTo(fontSizePost: CGFloat,
                         withDuration duration: CFTimeInterval = 0.5,
                                      callback: (() -> ())? = nil)
  {
    let fontSizePre = animatingLayer.fontSize
    let animation = CABasicAnimation()
    animation.duration = duration
    animation.toValue = fontSizePost
    animation.fillMode = kCAFillModeForwards
    
    fontSizeWillChangeTo(fontSizePost)
    
    CATransaction.begin()
    CATransaction.setCompletionBlock {
      self.animatingLayer.fontSize = fontSizePost
      self.animatingLayer.setNeedsDisplay()
      self.fontSizeDidChangeFrom(fontSizePre)
      callback?()
    }
    CATransaction.setAnimationTimingFunction(CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseInEaseOut))
    
    animatingLayer.addAnimation(animation, forKey: "fontSize")
    
    CATransaction.commit()
  }
  func fontSizeWillChangeTo(fontSizePost: CGFloat) {
    targetFontSize = fontSizePost
    if fontSize < fontSizePost {
      invalidateTextSize()
    }
  }
  func fontSizeDidChangeFrom(fontSizePre: CGFloat) {
    targetFontSize = nil
    if fontSizePre > fontSize  {
      invalidateTextSize()
    }
  }
  func invalidateTextSize() {
    invalidateIntrinsicContentSize()
    animatingLayer.setNeedsDisplay()
  }
}
