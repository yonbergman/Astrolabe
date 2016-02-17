import UIKit
import Static
import Astrolabe

extension Astrolabe.Modules {
  static var home: HomeModule!
  static var activity: ActivityModule!
  static var flow: FlowModule!
  static var settings: SettingsModule!
  static var segue: SegueModule!

  static func setup(navigationController: UINavigationController) {
    Astrolabe.Modules.home = HomeModule(navigationController: navigationController)
    Astrolabe.Modules.activity = ActivityModule(navigationController: navigationController)
    Astrolabe.Modules.flow = FlowModule(navigationController: navigationController)
    Astrolabe.Modules.settings = SettingsModule(navigationController: navigationController)
    Astrolabe.Modules.segue = SegueModule(navigationController: navigationController)
  }

}
