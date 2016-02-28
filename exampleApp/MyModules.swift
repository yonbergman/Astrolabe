import UIKit
import Static
import Astrolabe

extension Astrolabe.Modules {
  static var home: HomeModule!
  static var activity: ActivityModule!
  static var flow: FlowModule!
  static var settings: SettingsModule!
  static var segue: SegueModule!

  static func setup() {
    Astrolabe.Modules.home = HomeModule()
    Astrolabe.Modules.activity = ActivityModule()
    Astrolabe.Modules.flow = FlowModule()
    Astrolabe.Modules.settings = SettingsModule()
    Astrolabe.Modules.segue = SegueModule()
  }

}
