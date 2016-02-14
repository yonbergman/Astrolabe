import UIKit
import Static
import Astrolabe

public var kHomeHasNavBar = true

typealias SettingsCallback = ((Bool) -> Void)

class SettingsModule: FlowModule {

  private var callback: SettingsCallback?

  func showSettings(callback: SettingsCallback? = nil) {
    perserveState()

    let vc = SettingsViewController()
    vc.parentModule = self
    self.callback = callback
    showViewController(vc, animated: true)
  }

  private func setHomeHasNavBar(homeHasNavBar: Bool) {
    callback?(homeHasNavBar)
    returnToStateAnimated(true)
  }
}

private class SettingsViewController: SimpleViewController {

  var parentModule: SettingsModule?

  private override func setupTable() {
    title = "Settings"

    dataSource.sections = [Section(header: "Home Navigation Bar", rows: [
      Row(text: "Shown", accessory: kHomeHasNavBar ? .Checkmark : .None, selection: { [unowned self] in
        self.parentModule?.setHomeHasNavBar(true)
        }),
      Row(text: "Hidden", accessory: kHomeHasNavBar ? .None : .Checkmark, selection: { [unowned self] in
        self.parentModule?.setHomeHasNavBar(false)
      })
      ])
    ]
  }
}