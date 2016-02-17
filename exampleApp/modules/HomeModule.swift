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
        Row(text: "History", accessory: .DisclosureIndicator, selection: {
          Astrolabe.Modules.activity.showActivity()
        }),
        Row(text: "Send Message", accessory: .DisclosureIndicator, selection: {
          Astrolabe.Modules.flow.startFlow()
        }),
        Row(text: "How it Works", accessory: .DisclosureIndicator, selection: {
          Astrolabe.Modules.segue.startFlow()
        }),
        Row(text: "Settings", accessory: .DisclosureIndicator, selection: showSettings),
      ]),
      Section(header: "Deeplink URLs", rows: [
        Row(text: "History", detailText: "exampleApp://history", cellClass: SubtitleCell.self, selection: {
          Astrolabe.router.navigate("history")
          }),
        Row(text: "Random Message History", detailText: "exampleApp://history/random", cellClass: SubtitleCell.self, selection: {
          Astrolabe.router.navigate("history/random")
        }),
        Row(text: "Message 1 History", detailText: "exampleApp://history?id=1", cellClass: SubtitleCell.self, selection: {
          Astrolabe.router.navigate("history?id=1")
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

