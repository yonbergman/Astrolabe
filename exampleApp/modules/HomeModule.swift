import UIKit
import Static
import Astrolabe

class HomeModule: NavigationModule {
  weak private var homeVC: HomeViewController?
  
  func showHome(animated: Bool = true) {
    let homeVC = self.homeVC ?? HomeViewController()
    self.showRootViewController(homeVC, animated: animated)
    self.homeVC = homeVC
  }
}

private class HomeViewController: SimpleViewController {

  override func setupTable() {
    title = "Home"
    dataSource.sections = [
      Section(rows: [
        Row(text: "Activity", selection: {
          Astrolabe.Modules.activity.showActivity()
        }),
        Row(text: "Creation Flow",selection: {
          Astrolabe.Modules.creation.startCreationFlow()
        }),
        Row(text: "Settings", selection: showSettings),
      ]),
      Section(header: "Deeplink URLs", rows: [
        Row(text: "Activity", detailText: "astrolabe://activity", cellClass: SubtitleCell.self, selection: {
          Astrolabe.router.navigate("activity")
          }),
        Row(text: "Activity Item", detailText: "astrolabe://activity?id=1", cellClass: SubtitleCell.self, selection: {
          Astrolabe.router.navigate("activity?id=1")
        }),
      ])
    ]
  }


  private override func viewWillAppear(animated: Bool) {
    if !kHomeHasNavBar {
      navigationController?.setNavigationBarHidden(true, animated: animated)
    }
  }

  private override func viewWillDisappear(animated: Bool) {
    navigationController?.setNavigationBarHidden(false, animated: animated)
  }


  private func showSettings() {
    Astrolabe.Modules.settings.showSettings() { homeHasNavBar in
      kHomeHasNavBar = homeHasNavBar
    }
  }
}

