import UIKit
import Static

class SimpleViewController: UIViewController {

  lazy var tableView: UITableView! =  {
    let tv = UITableView()
    self.view.pinViewToEdges(tv)
    return tv
  }()

  let dataSource = DataSource()

  override func viewDidLoad() {
    super.viewDidLoad()
    setupTable()
    dataSource.tableView = tableView
    print("+ Alloc\t\(title!)")
  }

  func setupTable() {
  }

  deinit {
    print("- Dealloc\t\(title!)")
  }
}

extension UIView {

  func pinViewToEdges(subview: UIView) {
    self.addSubview(subview)
    subview.translatesAutoresizingMaskIntoConstraints = false
    let vConstraints = NSLayoutConstraint.constraintsWithVisualFormat("V:|[view]|", options: [], metrics: nil, views: ["view": subview])
    let hConstraints = NSLayoutConstraint.constraintsWithVisualFormat("H:|[view]|", options: [], metrics: nil, views: ["view": subview])
    self.addConstraints(vConstraints + hConstraints)
  }
  
}
