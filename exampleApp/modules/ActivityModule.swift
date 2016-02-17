import UIKit
import Static
import Astrolabe

class ActivityModule: NavigationModule {
  weak var activityVC: ActivityViewController?

  struct Activity {
    let message: String
    let from: String
  }

  static let MyActivities = [
    Activity(message: "What's up?", from: "Neil deGrasse Tyson"),
    Activity(message: "I think that should be ok", from: "Carl Sagan")
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
    router.registerRoute("history") { params in
      if let activity = ActivityModule.getActivityItem(params) {
        self.showActivityDetails(activity)
      } else {
        self.showActivity()
      }
      return true
    }
    router.registerRoute("history/random") { params in
      let randomIndex = Int(arc4random_uniform(UInt32(ActivityModule.MyActivities.count)))
      self.showActivityDetails(ActivityModule.MyActivities[randomIndex])
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
      title = "History"
      dataSource.sections = [
        Section(rows:
          ActivityModule.MyActivities.map { activity in
            Row(text: activity.message, detailText: activity.from, cellClass: SubtitleCell.self, selection: {
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
      title = "Message History"
      if let activity = activity {
        dataSource.sections = [
          Section(rows:
            [
              Row(text: "From", detailText: activity.from),
              Row(text: "Message", detailText: activity.message),
            ]
          ),
          Section(header: "Quick Actions",
            rows:
            [
              Row(text:"Jump Home", cellClass: ButtonCell.self, selection: {
                Astrolabe.Modules.home.showHome(true)
              }),
              Row(text:"Start Creation Flow", cellClass: ButtonCell.self, selection: {
                Astrolabe.Modules.flow.startFlow(FlowModule.FlowPayload(target: activity.from, message: nil))
              })
            ])
        ]
      }
    }
  }
}