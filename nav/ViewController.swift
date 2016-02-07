//
//  ViewController.swift
//  nav
//
//  Created by Bergman, Yon on 2/5/16.
//  Copyright © 2016 yonbergman. All rights reserved.
//

import UIKit
import Static

class ViewController: UIViewController {

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

