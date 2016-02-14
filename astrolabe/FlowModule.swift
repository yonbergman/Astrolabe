import Foundation

public class FlowModule: NavigationModule {
  var returnTarget: UIViewController?

  public func perserveState() {
    returnTarget = self.navigationController.topViewController
  }

  public func returnToStateAnimated(animated: Bool = false) {
    if let target = returnTarget {
      self.navigationController.popToViewController(target, animated: animated)
    } else {
      print("Astrolabe - missing target")
    }
  }
}