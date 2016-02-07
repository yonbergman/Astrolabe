import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

  var window: UIWindow?
  var navigationController: UINavigationController?

  func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
    window = UIWindow(frame: UIScreen.mainScreen().bounds)
    navigationController = UINavigationController()
    Modules.setup(navigationController!)
    Modules.home.showHome()
    window?.rootViewController = navigationController
    window?.makeKeyAndVisible()
    return true
  }

  func application(app: UIApplication, openURL url: NSURL, options: [String : AnyObject]) -> Bool {
    return Router.sharedInstance.route(url)
  }
}

