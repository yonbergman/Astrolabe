import UIKit
import Static
import Astrolabe

class ActivityModule: NavigationModule {
  weak var activityVC: ActivityViewController?

  struct Activity {
    let name: String
    let details: String
  }

  static let MyActivities = [
    Activity(name: "Activity #1", details: "Moshe Ufnik"),
    Activity(name: "Activity #2", details: "Bob Ha'Banai")
  ]

  func getActivityVC() -> ActivityViewController {
    let vc = self.activityVC ?? ActivityViewController()
    self.activityVC = vc
    return vc
  }

  func showActivity(animated: Bool = true) {
    let activityVC = getActivityVC()
    showViewController(activityVC, animated: animated)
  }

  func showActivityDetails(activity: Activity, animated: Bool = true) {
    let activityVC = getActivityVC()
    let activityDetailsVC = ActivityDetailsViewController()
    activityDetailsVC.activity = activity
    showViewControllers([activityVC, activityDetailsVC], animated: animated)
  }

  override func registerRoutes(router: Router) {
    router.registerRoute("activity") { params in
      if let activity = ActivityModule.getActivityItem(params) {
        self.showActivityDetails(activity)
      } else {
        self.showActivity()
      }
      return true
    }
  }


  static func getActivityItem(params: [NSURLQueryItem]) -> Activity? {
    if let idString = Router.getParameter("id", params: params), id = Int(idString) where id < ActivityModule.MyActivities.count {
      return ActivityModule.MyActivities[id]
    }
    return nil
  }

  class ActivityViewController: SimpleViewController {
    override func setupTable() {
      title = "Activity"
      dataSource.sections = [
        Section(rows:
          ActivityModule.MyActivities.map { activity in
            Row(text: activity.name, detailText: activity.details, selection: {
              Astrolabe.Modules.activity.showActivityDetails(activity, animated: true)
            })
          }
        )
      ]
    }
  }

  class ActivityDetailsViewController: SimpleViewController {
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
                Astrolabe.Modules.home.showHome(true)
              }),
              Row(text:"Start Creation Flow", selection: {
                Astrolabe.Modules.creation.startCreationFlow(CreationModule.CreationPayload(price: nil, target: activity.details))
              })
            ])
        ]
      }
    }
  }
}