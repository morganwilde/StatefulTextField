//
//  StatefulTextField.swift
//  TextField
//
//  Created by Morgan Wilde on 7/28/16.
//  Copyright © 2016 Morgan Wilde. All rights reserved.
//

import UIKit

let snowColor = UIColor(white: 255/255.0, alpha: 1)
let mercuryColor = UIColor(white: 230/255.0, alpha: 1)
let silverColor = UIColor(white: 204/255.0, alpha: 1)
let magnesiumColor = UIColor(white: 179/255.0, alpha: 1)
let aluminumColor = UIColor(white: 153/255.0, alpha: 1)
let nickelColor = UIColor(white: 128/255.0, alpha: 1)
let tinColor = UIColor(white: 127/255.0, alpha: 1)
let steelColor = UIColor(white: 102/255.0, alpha: 1)
let ironColor = UIColor(white: 76/255.0, alpha: 1)
let tungstenColor = UIColor(white: 51/255.0, alpha: 1)
let leadColor = UIColor(white: 25/255.0, alpha: 1)
let licoriceColor = UIColor(white: 0/255.0, alpha: 1)

class StatefulTextField: UIView {
  
  enum State: Int {
    case Unfocused
    case Focusing
    case Focused
    case Filled
  }
  
  let titleSizeAnimationDuration: NSTimeInterval = 0.5
  let titlePositionAnimationDuration: NSTimeInterval = 0.25
  
  let paddingVertical: CGFloat = 8
  
  var titleLabel: ToggleableTextLabel!
  var textField: BorderedTextField!
  var actionButton: UIButton!
  
  var state: State = .Unfocused {
    didSet {
      print(state)
    }
  }
  var statefulConstraints = [State: [NSLayoutConstraint]]()
  
  var text: String? {
    set {
      textField.text = newValue
//      if newValue?.characters.count > 0 {
//        state = .Filled
//      }
    }
    get { return textField.text }
  }
  
  init(title: String) {
    super.init(frame: CGRect())
    
    backgroundColor = mercuryColor
    translatesAutoresizingMaskIntoConstraints = false
    
    titleLabel = ToggleableTextLabel(text: title, toggleFontSizeFrom: 50, to: 14)
    addSubview(titleLabel)
    titleLabel.leadingAnchor.constraintEqualToAnchor(leadingAnchor, constant: 16).active = true
    
    textField = BorderedTextField()
//    textField.backgroundColor = UIColor.greenColor()
    textField.delegate = self
    textField.font = UIFont.systemFontOfSize(50)
    textField.minimumFontSize = 14
    textField.adjustsFontSizeToFitWidth = true
    textField.clearButtonMode = .WhileEditing
    textField.hidden = true
    textField.borders = [.Bottom]
    addSubview(textField)
    textField.leadingAnchor.constraintEqualToAnchor(leadingAnchor, constant: 16).active = true
    textField.centerYAnchor.constraintEqualToAnchor(centerYAnchor).active = true
    
    actionButton = UIButton()
    actionButton.backgroundColor = UIColor.orangeColor()
    actionButton.setTitle("EDIT", forState: .Normal)
    actionButton.hidden = true
    actionButton.translatesAutoresizingMaskIntoConstraints = false
    addSubview(actionButton)
    actionButton.leadingAnchor.constraintEqualToAnchor(textField.trailingAnchor, constant: -8).active = true
    actionButton.trailingAnchor.constraintEqualToAnchor(trailingAnchor, constant: -8).active = true
    actionButton.bottomAnchor.constraintEqualToAnchor(textField.bottomAnchor).active = true
    
    statefulConstraints[.Unfocused] = [
      titleLabel.centerYAnchor.constraintEqualToAnchor(centerYAnchor),
    ]
    statefulConstraints[.Focusing] = [
      titleLabel.topAnchor.constraintEqualToAnchor(topAnchor, constant: 8),
      textField.widthAnchor.constraintEqualToAnchor(widthAnchor, constant: -32),
    ]
    statefulConstraints[.Focused] = [
      statefulConstraints[.Focusing]![0],
      statefulConstraints[.Focusing]![1],
    ]
    statefulConstraints[.Filled] = [
      titleLabel.topAnchor.constraintEqualToAnchor(topAnchor, constant: 8),
      textField.trailingAnchor.constraintEqualToAnchor(actionButton.leadingAnchor, constant: 8),
    ]
    
    NSLayoutConstraint.activateConstraints(statefulConstraints[state]!)
  }
  required init?(coder aDecoder: NSCoder) {
    return nil
  }
}

// MARK: Layout

extension StatefulTextField {
  override func intrinsicContentSize() -> CGSize {
    let height = (
      2 * (paddingVertical + titleLabel.getSizeForState(.Small).height) +
      titleLabel.getSizeForState(.Big).height
    )
    return CGSize(width: UIViewNoIntrinsicMetric, height: height)
  }
}

// MARK: Events

extension StatefulTextField {
  override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
    if state == .Unfocused {
      transitionStateTo(.Focusing)
    }
//    if state == .Unfocused {
//      titleLabel.toggleWithDuration(titleSizeAnimationDuration) {
//        let previousState = self.transitionStateTo(.Focused)
//        self.animateConstraintsFromState(previousState, toState: self.state) {
//          self.textField.hidden = false
//          self.textField.becomeFirstResponder()
//          self.textField.showBorders(true)
//        }
//      }
//    } else if state == .Focused {
//      let previousState = self.transitionStateTo(.Unfocused)
//      textField.resignFirstResponder()
//      textField.hidden = true
//      self.animateConstraintsFromState(previousState, toState: self.state) {
//        self.titleLabel.toggleWithDuration(self.titleSizeAnimationDuration)
//      }
//    }
  }
  func animateConstraintsFromState(previousState: State, toState nextState: State, callback: (() -> ())? = nil) {
    UIView.animateWithDuration(0, animations: { self.layoutIfNeeded() }) {
      completed in
      if completed {
        UIView.animateWithDuration(self.titlePositionAnimationDuration, animations: {
          NSLayoutConstraint.deactivateConstraints(self.statefulConstraints[previousState]!)
          NSLayoutConstraint.activateConstraints(self.statefulConstraints[nextState]!)
          self.layoutIfNeeded()
        }) {
          completed in
          if completed {
            callback?()
          }
        }
      }
    }
  }
  func transitionStateTo(next: State) -> State {
    let previous = state
    
    switch (previous, next) {
    case (.Unfocused, .Focusing):
      titleLabel.toggleWithDuration(titleSizeAnimationDuration) {
        self.animateConstraintsFromState(previous, toState: next) {
          self.state = next
          self.transitionStateTo(.Focused)
        }
      }
    case (_, .Focused):
      state = next
      textField.hidden = false
      textField.becomeFirstResponder()
      textField.showBorders(true)
      
    case (.Focused, .Filled):
      state = next
      textField.showBorders(false)
      textField.resignFirstResponder()
      
    case (.Focused, .Unfocused):
      textField.showBorders(false)
      textField.resignFirstResponder()
      textField.hidden = true
      self.animateConstraintsFromState(previous, toState: next) {
        self.titleLabel.toggleWithDuration(self.titleSizeAnimationDuration) {
          self.state = next
        }
      }
      
      
    default: break
    }
    
    return previous
  }
}

// MARK: UITextFieldDelegate

extension StatefulTextField: UITextFieldDelegate {
  func textFieldShouldBeginEditing(textField: UITextField) -> Bool {
    if state != .Focused {
      transitionStateTo(.Focused)
    }
    return true
  }
  func textFieldShouldReturn(textField: UITextField) -> Bool {
    if textField.text?.characters.count > 0 {
      transitionStateTo(.Filled)
    } else {
      transitionStateTo(.Unfocused)
    }
    return true
  }
}
