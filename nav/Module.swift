//
//  Module.swift
//  nav
//
//  Created by Bergman, Yon on 2/5/16.
//  Copyright © 2016 yonbergman. All rights reserved.
//

import UIKit
import Static

class Modules {
  static var home: HomeModule!
  static var activity: ActivityModule!
  static var creation: CreationModule!
  static var choose: ChooseModule!

  static func setup(navigationController: UINavigationController) {
    Modules.home = HomeModule(navigationController: navigationController)
    Modules.activity = ActivityModule(navigationController: navigationController)
    Modules.creation = CreationModule(navigationController: navigationController)
    Modules.choose = ChooseModule(navigationController: navigationController)
  }
}

class Module {
  let navigationController: UINavigationController

  init(navigationController: UINavigationController) {
    self.navigationController = navigationController
  }

  func backstackContainsVC(vc: UIViewController) -> Bool {
    return navigationController.viewControllers.contains(vc)
  }

  func showViewController(vc: UIViewController, animated: Bool = false) {
    if backstackContainsVC(vc) {
      navigationController.popToViewController(vc, animated: animated)
    } else {
      navigationController.pushViewController(vc, animated: animated)
    }
  }

  func replaceTopVC(vc: UIViewController, animated: Bool = false) {
    var newList = navigationController.viewControllers
    newList.removeLast()
    newList.append(vc)
    navigationController.setViewControllers(newList, animated: animated)
  }

}
