import UIKit
import Static
import Astrolabe

extension Astrolabe.Modules {
  static var home: HomeModule!
  static var activity: ActivityModule!
  static var creation: CreationModule!
  static var settings: SettingsModule!

  static func setup(navigationController: UINavigationController) {
    Astrolabe.Modules.home = HomeModule(navigationController: navigationController)
    Astrolabe.Modules.activity = ActivityModule(navigationController: navigationController)
    Astrolabe.Modules.creation = CreationModule(navigationController: navigationController)
    Astrolabe.Modules.settings = SettingsModule(navigationController: navigationController)
  }

}
