//
//  ViewController.swift
//  TextField
//
//  Created by Morgan Wilde on 7/24/16.
//  Copyright © 2016 Morgan Wilde. All rights reserved.
//

//import UIKit
//import Parse
//
//class ViewController: UIViewController {
//
//  var animatingTextLabel: ToggleableTextLabel!
//}
//
//// MARK: View Lifecycle
//
//extension ViewController {
//  override func viewDidLoad() {
//    super.viewDidLoad()
//    
//    animatingTextLabel = ToggleableTextLabel(text: "Label", toggleFontSizeFrom: 10, to: 150)
//    view.addSubview(animatingTextLabel)
//
//    animatingTextLabel.leadingAnchor.constraintEqualToAnchor(view.leadingAnchor, constant: 16).active = true
//    animatingTextLabel.centerYAnchor.constraintEqualToAnchor(view.centerYAnchor).active = true
//  }
//  override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
//    animatingTextLabel.toggleWithDuration(1)
//  }
//}

//
//  ViewController.swift
//  TextField
//
//  Created by Morgan Wilde on 7/24/16.
//  Copyright © 2016 Morgan Wilde. All rights reserved.
//

import UIKit
import Parse

class ViewController: UIViewController {
  
  var statefulTextField: StatefulTextField!
}

// MARK: View Lifecycle

extension ViewController {
  override func viewDidLoad() {
    super.viewDidLoad()
    
    statefulTextField = StatefulTextField(title: "Title")
    view.addSubview(statefulTextField)
    
    statefulTextField.widthAnchor.constraintEqualToAnchor(view.widthAnchor).active = true
    statefulTextField.leadingAnchor.constraintEqualToAnchor(view.leadingAnchor).active = true
    statefulTextField.centerYAnchor.constraintEqualToAnchor(view.centerYAnchor).active = true
    print("bob")
  }
//  override func viewDidAppear(animated: Bool) {
//    super.viewDidAppear(animated)
//    print(statefulTextField.titleLabel.getSizeForState(.Big))
//    print(statefulTextField.titleLabel.getSizeForState(.Small))
//    print(statefulTextField.textField.frame.height)
//    print(statefulTextField.frame.height)
//  }
}

