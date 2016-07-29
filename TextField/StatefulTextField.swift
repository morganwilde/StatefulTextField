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
    case Focused
    
    mutating func transition() -> State {
      let previous = self
      if let nextState = State(rawValue: (self.rawValue + 1) % 2) {
        self = nextState
      }
      return previous
    }
  }
  
  let titleSizeAnimationDuration: NSTimeInterval = 0.5
  let titlePositionAnimationDuration: NSTimeInterval = 0.5
  
  let paddingVertical: CGFloat = 8
  
  var titleLabel: ToggleableTextLabel!
  var textField: UITextField!
  var state: State = .Unfocused
  var statefulConstraints = [State: [NSLayoutConstraint]]()
  
  init(title: String) {
    super.init(frame: CGRect())
    
    backgroundColor = mercuryColor
    translatesAutoresizingMaskIntoConstraints = false
    
    titleLabel = ToggleableTextLabel(text: title, toggleFontSizeFrom: 50, to: 10)
    addSubview(titleLabel)
    titleLabel.leadingAnchor.constraintEqualToAnchor(leadingAnchor, constant: 16).active = true
    
    textField = UITextField(frame: CGRect())
    textField.font = UIFont.systemFontOfSize(50)
    textField.returnKeyType = .Done
    textField.hidden = true
    textField.translatesAutoresizingMaskIntoConstraints = false
    addSubview(textField)
    textField.leadingAnchor.constraintEqualToAnchor(leadingAnchor, constant: 16).active = true
    textField.trailingAnchor.constraintEqualToAnchor(trailingAnchor, constant: -16).active = true
    textField.centerYAnchor.constraintEqualToAnchor(centerYAnchor).active = true
    
    statefulConstraints[.Unfocused] = [
      titleLabel.centerYAnchor.constraintEqualToAnchor(centerYAnchor),
    ]
    statefulConstraints[.Focused] = [
      titleLabel.topAnchor.constraintEqualToAnchor(topAnchor, constant: 8),
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
    return CGSize(width: UIViewNoIntrinsicMetric,
                  height: height)
  }
}

// MARK: Events

extension StatefulTextField {
  override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
    if state == .Unfocused {
      titleLabel.toggleWithDuration(titleSizeAnimationDuration) {
        let previousState = self.state.transition()
        self.animateConstraintsFromState(previousState, toState: self.state) {
          self.textField.hidden = false
          self.textField.becomeFirstResponder()
        }
      }
    } else if state == .Focused {
      let previousState = self.state.transition()
      textField.resignFirstResponder()
      textField.hidden = true
      self.animateConstraintsFromState(previousState, toState: self.state) {
        self.titleLabel.toggleWithDuration(self.titleSizeAnimationDuration)
      }
    }
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
}
