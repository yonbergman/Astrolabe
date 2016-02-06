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
  static func setup(navigationController: UINavigationController) {
    Modules.home = HomeModule(navigationController: navigationController)
    Modules.activity = ActivityModule(navigationController: navigationController)
    Modules.creation = CreationModule(navigationController: navigationController)
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

class HomeModule: Module {
  weak var homeVC: HomeViewController?
  func showHome(animated: Bool = true) {
    let homeVC = self.homeVC ?? HomeViewController()
    if backstackContainsVC(homeVC) {
      self.navigationController.popToViewController(homeVC, animated: animated)
    } else {
      self.navigationController.setViewControllers([homeVC], animated: animated)
    }
    self.homeVC = homeVC
  }

  class HomeViewController: ViewController {
    override func setupTable() {
      title = "Home"
      dataSource.sections = [
        Section(rows: [
          Row(text: "Activity", selection: {
            Modules.activity.showActivity(true)
          }),
          Row(text: "Creation Flow",selection: {
            Modules.creation.startCreationFlow()
          })
          ])
      ]
    }
  }
}

class ActivityModule: Module {
  weak var activityVC: ActivityViewController?

  struct Activity {
    let name: String
    let details: String
  }

  static let MyActivities = [
    Activity(name: "Activity #1", details: "Moshe Ufnik"),
    Activity(name: "Activity #2", details: "Bob Ha'Banai")
  ]

  func showActivity(animated: Bool = true) {
    let activityVC = self.activityVC ?? ActivityViewController()
    showViewController(activityVC)
    self.activityVC = activityVC
  }

  func showActivityDetails(activity: Activity, animated: Bool = true) {
    let activityDetailsVC = ActivityDetailsViewController()
    activityDetailsVC.activity = activity
    navigationController.pushViewController(activityDetailsVC, animated: animated)
  }


  class ActivityViewController: ViewController {
    override func setupTable() {
      title = "Activity"
      dataSource.sections = [
        Section(rows:
          ActivityModule.MyActivities.map { activity in
            Row(text: activity.name, detailText: activity.details, selection: {
              Modules.activity.showActivityDetails(activity, animated: true)
            })
          }
          )
      ]
    }
  }

  class ActivityDetailsViewController: ViewController {
    var activity: Activity! {
      didSet {
        setupTable()
      }
    }
    override func setupTable() {
      title = "Activity Details"
      if let activity = activity {
        dataSource.sections = [
          Section(rows:
            [
              Row(text: "Name", detailText: activity.name),
              Row(text: "Details", detailText: activity.details),
            ]
          ),
          Section(header: "Quick Actions",
            rows:
            [
              Row(text:"Jump Home", selection: {
                Modules.home.showHome(true)
              }),
              Row(text:"Start Creation Flow", selection: {
                Modules.creation.startCreationFlow(CreationModule.CreationPayload(price: nil, target: activity.details))
              })
            ])
        ]
      }
    }
  }
}

protocol CreationFirstTimeDelegate: class {
  func clickedOK()
}

protocol CreationTargetDelegate: class {
  func selectedTarget(target: String)
}

protocol CreationPriceDelegate: class {
  func selectedPrice(price: String)
}

protocol CreationSuccessDelegate: class {
  func restartFlow()
  func endFlow()
}

class CreationModule: Module {

  struct CreationPayload {
    var price: String?
    var target: String?
  }

  var didSeeFirstTime = false
  var payload: CreationPayload!
  var returnTarget: UIViewController!

  func startCreationFlow(payload: CreationPayload? = CreationPayload()) {
    returnTarget = navigationController.topViewController
    self.payload = payload
    showNextVC(true)
  }

  private func showNextVC(animated: Bool = false) {
    showViewController(chooseNextVC(), animated: animated)
  }

  private func chooseNextVC() -> UIViewController {
    if !didSeeFirstTime {
      let vc = CreationFirstTimeViewController()
      vc.flowDelegate = self
      return vc
    }
    if payload.target == nil {
      let vc = CreationTargetViewController()
      vc.flowDelegate = self
      return vc
    }
    if payload.price == nil {
      let vc = CreationPriceViewController()
      vc.flowDelegate = self
      return vc
    }
    let vc = CreationSuccessViewController()
    vc.payload = self.payload
    vc.flowDelegate = self
    return vc
  }

  class CreationFirstTimeViewController: ViewController {

    weak var flowDelegate: CreationFirstTimeDelegate?

    override func setupTable() {
      title = "Creation - Intro"
      dataSource.sections = [
        Section(header: "Welcome", rows: [
          Row(text: "OK", selection: { [unowned self] in
            self.flowDelegate?.clickedOK()
          })
          ]
        )
      ]
    }
  }

  class CreationTargetViewController: ViewController {
    weak var flowDelegate: CreationTargetDelegate?
    override func setupTable() {
      title = "Creation - Step 1"
      dataSource.sections = [
        Section(header: "Choose Target", rows:
          ["Crystal Watson", "Jenny Collins", "Terrance Byrd", "Kurt Harvey"].map { u in
            Row(text: u, selection: { [unowned self] in
              self.flowDelegate?.selectedTarget(u!)
            })
          }
        )
      ]
    }
  }

  class CreationPriceViewController: ViewController {
    weak var flowDelegate: CreationPriceDelegate?
    override func setupTable() {
      title = "Creation - Step 2"
      dataSource.sections = [
        Section(header: "Choose Price", rows:
          ["$3.50", "$5.00", "$6.00", "$100.00"].map { u in
            Row(text: u, selection: { [unowned self] in
              self.flowDelegate?.selectedPrice(u!)
            })
          }
        )
      ]
    }
  }

  class CreationSuccessViewController: ViewController {
    var payload: CreationPayload?
    weak var flowDelegate: CreationSuccessDelegate?
    override func setupTable() {
      title = "Creation - Success"
      dataSource.sections = [
        Section(header: "Success", rows: [
          Row(text: "Successfully Sent \(payload!.price!) to \(payload!.target!)")
        ]),
        Section(header: "Choose Action", rows: [
          Row(text: "Restart Flow", selection: { [unowned self] in
            self.flowDelegate?.restartFlow()
            }),
          Row(text: "Done", selection: { [unowned self] in
            self.flowDelegate?.endFlow()
          })
          ]
        )
      ]
    }
  }


}

extension CreationModule: CreationFirstTimeDelegate {
  func clickedOK() {
    didSeeFirstTime = true
    replaceTopVC(chooseNextVC(), animated: true)
  }
}

extension CreationModule: CreationTargetDelegate {
  func selectedTarget(target: String) {
    payload.target = target
    showNextVC(true)
  }
}

extension CreationModule: CreationPriceDelegate {
  func selectedPrice(price: String) {
    payload.price = price
    showNextVC(true)
  }
}

extension CreationModule: CreationSuccessDelegate {

  func restartFlow() {
    payload = CreationPayload()
    navigationController.popToViewController(returnTarget, animated: false)
    navigationController.pushViewController(chooseNextVC(), animated: true)
  }

  func endFlow() {
    navigationController.popToViewController(returnTarget, animated: true)
  }

}