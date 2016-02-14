import Foundation

public class NavigationModule: Module {
  
  public let navigationController: UINavigationController

  public init(navigationController: UINavigationController) {
    self.navigationController = navigationController
    super.init()
  }

  public func backstackContainsVC(vc: UIViewController) -> Bool {
    return navigationController.viewControllers.contains(vc)
  }

  public func showViewController(vc: UIViewController, animated: Bool = false) {
    if backstackContainsVC(vc) {
      navigationController.popToViewController(vc, animated: animated)
    } else {
      navigationController.pushViewController(vc, animated: animated)
    }
  }

  public func showViewControllers(vcs: [UIViewController], animated: Bool = false) {
    let currentList = navigationController.viewControllers
    let newList = vcs.filter { !currentList.contains($0) }
    let joinedList = currentList + newList
    navigationController.setViewControllers(joinedList, animated: animated)
  }

  public func showRootViewController(vc: UIViewController, animated: Bool = false) {
    if backstackContainsVC(vc) {
      self.navigationController.popToViewController(vc, animated: animated)
    } else {
      self.navigationController.setViewControllers([vc], animated: animated)
    }
  }

  public func replaceTopVC(vc: UIViewController, animated: Bool = false) {
    var newList = navigationController.viewControllers
    newList.removeLast()
    newList.append(vc)
    navigationController.setViewControllers(newList, animated: animated)
  }
  
}