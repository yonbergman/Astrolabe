//
//  UIViewExtensions.swift
//  nav
//
//  Created by Bergman, Yon on 2/6/16.
//  Copyright © 2016 yonbergman. All rights reserved.
//

import Foundation
import UIKit

extension UIView {
  func pinViewToEdges(subview: UIView) {
    self.addSubview(subview)
    subview.translatesAutoresizingMaskIntoConstraints = false
    let vConstraints = NSLayoutConstraint.constraintsWithVisualFormat("V:|[view]|", options: [], metrics: nil, views: ["view": subview])
    let hConstraints = NSLayoutConstraint.constraintsWithVisualFormat("H:|[view]|", options: [], metrics: nil, views: ["view": subview])
    self.addConstraints(vConstraints + hConstraints)
  }

}