import UIKit
import Static

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
          Row(text: "Choose Color", selection: chooseColor),
          Row(text: "Creation Flow",selection: {
            Modules.creation.startCreationFlow()
          })
        ])
      ]
    }

    private func chooseColor() {
      Modules.choose.chooseColor() { name,color in
        self.navigationController?.navigationBar.backgroundColor = color
      }
    }
  }

}
