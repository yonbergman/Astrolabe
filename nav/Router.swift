import Foundation

typealias RoutingInput = (String, [NSURLQueryItem])
typealias RoutingMethod = (RoutingInput -> Bool)

class Router {
  static var scheme: String? = "astrolabe"
  private var routingMethods: [RoutingMethod] = []
  static var sharedInstance: Router = Router()

  func registerRouting(routingMethod: RoutingMethod) {
    routingMethods.append(routingMethod)
  }

  func route(url: NSURL) -> Bool {
    let c = NSURLComponents(URL: url, resolvingAgainstBaseURL: false)
    if url.scheme != Router.scheme { return false }
    let path = url.host ?? ""
    let query = c?.queryItems ?? []

    return routingMethods.reduce(false, combine: { didTrigger, method in
      if didTrigger { return true }
      return method((path, query))
    })
  }

  static func findID(params: [NSURLQueryItem]) -> Int? {
    return params.reduce(nil, combine: { id, item in
      if id != nil { return id }
      if let value = item.value where item.name == "id" {
        return Int(value)
      }
      return nil
    })
  }

}
