import UIKit
import Static

class HomeModule: Module {
  weak private var homeVC: HomeViewController?
  
  func showHome(animated: Bool = true) {
    let homeVC = self.homeVC ?? HomeViewController()
    if backstackContainsVC(homeVC) {
      self.navigationController.popToViewController(homeVC, animated: animated)
    } else {
      self.navigationController.setViewControllers([homeVC], animated: animated)
    }
    self.homeVC = homeVC
  }
}

private class HomeViewController: ViewController {

  override func setupTable() {
    title = "Home"
    dataSource.sections = [
      Section(rows: [
        Row(text: "Activity", selection: {
          Modules.activity.showActivity(true)
        }),
        Row(text: "Choose Color", selection: chooseColor),
        Row(text: "Creation Flow",selection: {
          Modules.creation.startCreationFlow()
        })
      ]),
      Section(header: "DeepLink URLS", rows: [
        Row(text: "Activity", detailText: "astrolabe://activity", cellClass: SubtitleCell.self, selection: {
              UIApplication.sharedApplication().openURL(NSURL(string: "astrolabe://activity")!)
          }),
        Row(text: "Activity Item", detailText: "astrolabe://activity?id=1", cellClass: SubtitleCell.self, selection: {
          UIApplication.sharedApplication().openURL(NSURL(string: "astrolabe://activity?id=1")!)
        }),
      ])
    ]

  }

  private func chooseColor() {
    Modules.choose.chooseColor() { name,color in
      self.navigationController?.navigationBar.backgroundColor = color
    }
  }
}

