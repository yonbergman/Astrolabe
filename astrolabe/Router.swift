import Foundation

public typealias RoutingParams = [NSURLQueryItem]
public typealias RoutingMethod = (RoutingParams -> Bool)

public class Router {
  static var scheme: String! { return Astrolabe.scheme }
  private var routes = [String: RoutingMethod]()
  static var sharedInstance: Router = Router()

  public func registerRoute(routePath: String, routingMethod: RoutingMethod) {
    if routes.keys.contains(routePath) { print("Astrolabe - already containes route for \(routePath), overwriting") }
    routes[routePath] = routingMethod
  }

  public func navigate(urn: String, scheme: String = Router.scheme) {
    guard let url = NSURL(string: "\(scheme)://\(urn)") else { return }
    UIApplication.sharedApplication().openURL(url)
  }

  public func route(url: NSURL) -> Bool {
    let urlComponents = NSURLComponents(URL: url, resolvingAgainstBaseURL: false)
    if url.scheme != Astrolabe.scheme { return false }
    let path = url.host ?? url.path ?? ""
    let query = urlComponents?.queryItems ?? []

    if let routingMethod = routes[path] {
      return routingMethod(query)
    }
    return false
  }

  public static func getParameter(name: String, params: [NSURLQueryItem]) -> String? {
    return params.filter { $0.name == name }.first?.value
  }

}
