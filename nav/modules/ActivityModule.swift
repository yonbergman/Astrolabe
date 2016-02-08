import UIKit
import Static

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
    showViewController(activityVC, animated: animated)
    self.activityVC = activityVC
  }

  func showActivityDetails(activity: Activity, animated: Bool = true) {
    let activityDetailsVC = ActivityDetailsViewController()
    activityDetailsVC.activity = activity
    navigationController.pushViewController(activityDetailsVC, animated: animated)
  }

  override func setupRouting() {

    func getActivityItem(params: [NSURLQueryItem]) -> Activity? {
      if let id = Router.findID(params) where id < ActivityModule.MyActivities.count {
        return ActivityModule.MyActivities[id]
      }
      return nil
    }

    Router.sharedInstance.registerRouting { path, params in
      let activity = getActivityItem(params)
      switch path {
      case "activity" where activity != nil:
        self.showActivityDetails(activity!)
        return true
      case "activity":
        self.showActivity(true)
        return true
      default:
        return false
      }
    }
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