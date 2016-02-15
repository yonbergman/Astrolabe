import Foundation

public class CheckpointNavigationModule: NavigationModule {
  private var checkpoints = [UIViewController]()

  public func saveCheckpoint() {
    if let vc = navigationController.topViewController {
      checkpoints.append(vc)
    } else {
      print("Astrolabe - No Top View Controller")
    }
  }

  public func returnToLastCheckpointAnimated(animated: Bool) {
    if let vc = checkpoints.popLast() {
      showViewController(vc, animated: animated)
    } else {
      print("Astrolabe - no checkpoints set")
    }
  }
}