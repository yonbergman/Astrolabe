import Foundation
import Astrolabe

class SegueModule: CheckpointNavigationModule {

  func startFlow(animated: Bool = true) {
    saveCheckpoint()
    if let vc = UIStoryboard(name: "SegueModule", bundle: nil).instantiateInitialViewController() as? SeguePage1 {
      showViewController(vc, animated: animated)
    }
  }

  private func flowEnded() {
    returnToLastCheckpointAnimated(true)
  }
}

class SeguePage1: UIViewController {
  @IBAction func unwindFromModalToPage1(storyboard: UIStoryboardSegue) {
  }
}

class SeguePage2: UIViewController {
}

class SeguePage3: UIViewController {

  @IBAction func done() {
    Astrolabe.Modules.segue.flowEnded()
  }
}

class SegueModalPage: UIViewController {

}

