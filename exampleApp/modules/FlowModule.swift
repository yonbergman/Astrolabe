import UIKit
import Static
import Astrolabe

class FlowModule: NavigationModule {

  struct FlowPayload {
    var target: String?
    var message: String?
  }

  var didSeeFirstTime = false
  var payload: FlowPayload!
  var returnTarget: UIViewController?

  func startFlow(payload: FlowPayload? = FlowPayload()) {
    saveReturnViewController()
    self.payload = payload
    showNextVC(true)
  }

  private func showNextVC(animated: Bool = false) {
    showViewController(chooseNextVC(), animated: animated)
  }

  private func chooseNextVC() -> UIViewController {
    if !didSeeFirstTime {
      return FlowIntroViewController.initialize(self)
    }
    if payload.target == nil {
      let vc = FlowTargetViewController()
      vc.flowDelegate = self
      return vc
    }
    if payload.message == nil {
      let vc = FlowMessageViewController()
      vc.flowDelegate = self
      return vc
    }
    if let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewControllerWithIdentifier("flow_success") as? FlowSuccessViewController {
      vc.payload = self.payload
      vc.flowDelegate = self
      return vc
    }
    return UIViewController()
  }


  private func saveReturnViewController() {
    returnTarget = self.navigationController.topViewController
  }

  private func returnToSavedViewControllerAnimated(animated: Bool = false) {
    if let target = returnTarget {
      self.navigationController.popToViewController(target, animated: animated)
    } else {
      print("Astrolabe - missing target")
    }
  }

}


protocol FlowIntroDelegate: class {
  func clickedOK()
}

protocol FlowTargetDelegate: class {
  func selectedTarget(target: String)
}

protocol FlowMessageDelegate: class {
  func selectedMessage(message: String)
}

protocol FlowSuccessDelegate: class {
  func restartFlow()
  func endFlow()
}


private class FlowIntroViewController: SimpleViewController {

  static func initialize(flowDelegate: FlowIntroDelegate? = nil) -> FlowIntroViewController {
    let vc = FlowIntroViewController()
    vc.flowDelegate = flowDelegate
    return vc
  }

  weak var flowDelegate: FlowIntroDelegate?

  override func setupTable() {
    title = "Send Message"
    dataSource.sections = [
      Section(header: "Welcome", rows: [
        Row(text: "You'll see this view only once"),
        Row(text: "OK", cellClass: ButtonCell.self,  selection: { [unowned self] in
          self.flowDelegate?.clickedOK()
          })
        ]
      )
    ]
  }
}

private class FlowTargetViewController: SimpleViewController {
  weak var flowDelegate: FlowTargetDelegate?
  override func setupTable() {
    title = "Send Message"
    dataSource.sections = [
      Section(header: "Choose Target", rows:
        ["Nicolaus Copernicus", "Tycho Brahe", "Galileo Galilei", "Isaac Newton"].map { u in
          Row(text: u, selection: { [unowned self] in
            self.flowDelegate?.selectedTarget(u!)
            })
        }
      )
    ]
  }
}

private class FlowMessageViewController: SimpleViewController {
  weak var flowDelegate: FlowMessageDelegate?
  override func setupTable() {
    title = "Send Message"
    dataSource.sections = [
      Section(header: "Choose Message", rows:
        ["Hey, how are you?", "Reach for the stars!", "🚀🌕"].map { m in
          Row(text: m, selection: { [unowned self] in
            self.flowDelegate?.selectedMessage(m!)
            })
        }
      )
    ]
  }
}

class FlowSuccessViewController: UIViewController {

  @IBOutlet weak var tableView: UITableView!
  var payload: FlowModule.FlowPayload?
  weak var flowDelegate: FlowSuccessDelegate?
  var dataSource = DataSource()
  override func viewDidLoad() {
    super.viewDidLoad()
    title = "Send Message"
    dataSource.sections = [
      Section(header: "Success", rows: [
        Row(text: "Successfully Sent \"\(payload!.message!)\" to \(payload!.target!)")
        ]),
      Section(header: "Choose Action", rows: [
        Row(text: "Restart Flow", cellClass: ButtonCell.self, selection: { [unowned self] in
          self.flowDelegate?.restartFlow()
          }),
        Row(text: "Done", cellClass: ButtonCell.self, selection: { [unowned self] in
          self.flowDelegate?.endFlow()
          })
        ]
      )
    ]
    dataSource.tableView = self.tableView
  }

}


extension FlowModule: FlowIntroDelegate {
  func clickedOK() {
    didSeeFirstTime = true
    replaceTopVC(chooseNextVC(), animated: true)
  }
}

extension FlowModule: FlowTargetDelegate {
  func selectedTarget(target: String) {
    payload.target = target
    showNextVC(true)
  }
}

extension FlowModule: FlowMessageDelegate {
  func selectedMessage(message: String) {
    payload.message = message
    showNextVC(true)
  }
}

extension FlowModule: FlowSuccessDelegate {

  func restartFlow() {
    payload = FlowPayload()
    returnToSavedViewControllerAnimated(false)
    showViewController(chooseNextVC(), animated: true)
  }

  func endFlow() {
    returnToSavedViewControllerAnimated(true)
  }
  
}