import UIKit
import Static
import Astrolabe

class CreationModule: FlowModule {

  struct CreationPayload {
    var price: String?
    var target: String?
  }

  var didSeeFirstTime = false
  var payload: CreationPayload!
  var returnTarget: UIViewController!

  func startCreationFlow(payload: CreationPayload? = CreationPayload()) {
    perserveState()
    self.payload = payload
    showNextVC(true)
  }

  private func showNextVC(animated: Bool = false) {
    showViewController(chooseNextVC(), animated: animated)
  }

  private func chooseNextVC() -> UIViewController {
    if !didSeeFirstTime {
      return CreationFirstTimeViewController.initialize(self)
    }
    if payload.target == nil {
      let vc = CreationTargetViewController()
      vc.flowDelegate = self
      return vc
    }
    if payload.price == nil {
      let vc = CreationPriceViewController()
      vc.flowDelegate = self
      return vc
    }
    if let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewControllerWithIdentifier("creation_success") as? CreationSuccessViewController {
      vc.payload = self.payload
      vc.flowDelegate = self
      return vc
    }
    return UIViewController()
  }
}


protocol CreationFirstTimeDelegate: class {
  func clickedOK()
}

protocol CreationTargetDelegate: class {
  func selectedTarget(target: String)
}

protocol CreationPriceDelegate: class {
  func selectedPrice(price: String)
}

protocol CreationSuccessDelegate: class {
  func restartFlow()
  func endFlow()
}


class CreationFirstTimeViewController: SimpleViewController {

  static func initialize(flowDelegate: CreationFirstTimeDelegate? = nil) -> CreationFirstTimeViewController {
    let vc = CreationFirstTimeViewController()
    vc.flowDelegate = flowDelegate
    return vc
  }

  weak var flowDelegate: CreationFirstTimeDelegate?

  override func setupTable() {
    title = "Creation - Intro"
    dataSource.sections = [
      Section(header: "Welcome", rows: [
        Row(text: "You'll see this view only once"),
        Row(text: "OK", selection: { [unowned self] in
          self.flowDelegate?.clickedOK()
          })
        ]
      )
    ]
  }
}

class CreationTargetViewController: SimpleViewController {
  weak var flowDelegate: CreationTargetDelegate?
  override func setupTable() {
    title = "Creation - Step 1"
    dataSource.sections = [
      Section(header: "Choose Target", rows:
        ["Crystal Watson", "Jenny Collins", "Terrance Byrd", "Kurt Harvey"].map { u in
          Row(text: u, selection: { [unowned self] in
            self.flowDelegate?.selectedTarget(u!)
            })
        }
      )
    ]
  }
}

class CreationPriceViewController: SimpleViewController {
  weak var flowDelegate: CreationPriceDelegate?
  override func setupTable() {
    title = "Creation - Step 2"
    dataSource.sections = [
      Section(header: "Choose Price", rows:
        ["$3.50", "$5.00", "$6.00", "$100.00"].map { u in
          Row(text: u, selection: { [unowned self] in
            self.flowDelegate?.selectedPrice(u!)
            })
        }
      )
    ]
  }
}

class CreationSuccessViewController: UIViewController {

  @IBOutlet weak var tableView: UITableView!
  var payload: CreationModule.CreationPayload?
  weak var flowDelegate: CreationSuccessDelegate?
  var dataSource = DataSource()
  override func viewDidLoad() {
    super.viewDidLoad()
    title = "Creation - Success"
    dataSource.sections = [
      Section(header: "Success", rows: [
        Row(text: "Successfully Sent \(payload!.price!) to \(payload!.target!)")
        ]),
      Section(header: "Choose Action", rows: [
        Row(text: "Restart Flow", selection: { [unowned self] in
          self.flowDelegate?.restartFlow()
          }),
        Row(text: "Done", selection: { [unowned self] in
          self.flowDelegate?.endFlow()
          })
        ]
      )
    ]
    dataSource.tableView = self.tableView
  }

}


extension CreationModule: CreationFirstTimeDelegate {
  func clickedOK() {
    didSeeFirstTime = true
    replaceTopVC(chooseNextVC(), animated: true)
  }
}

extension CreationModule: CreationTargetDelegate {
  func selectedTarget(target: String) {
    payload.target = target
    showNextVC(true)
  }
}

extension CreationModule: CreationPriceDelegate {
  func selectedPrice(price: String) {
    payload.price = price
    showNextVC(true)
  }
}

extension CreationModule: CreationSuccessDelegate {

  func restartFlow() {
    payload = CreationPayload()
    returnToStateAnimated(false)
    showViewController(chooseNextVC(), animated: true)
  }

  func endFlow() {
    returnToStateAnimated(true)
  }
  
}