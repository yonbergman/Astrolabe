import UIKit
import Static

typealias Color = (String, UIColor)
typealias ColorCallback = ((Color) -> Void)

class ChooseModule: Module {

  private static let colors = [("Default", UIColor.clearColor()), ("Red", UIColor.redColor()), ("Green", UIColor.greenColor()), ("Blue", UIColor.blueColor())]

  private var callback: ColorCallback?

  func chooseColor(callback: ColorCallback? = nil) {
    let vc = ChooseViewController()
    vc.parentModule = self
    self.callback = callback
    showViewController(vc, animated: true)
  }

  private func choosenColor(color: Color) {
    callback?(color)
    self.navigationController.popViewControllerAnimated(true)
  }
}

private class ChooseViewController: ViewController {

  var parentModule: ChooseModule?

  private override func setupTable() {
    title = "Choose Color"
    dataSource.sections = [Section(rows:
      ChooseModule.colors.map { (name,color) in
        let view = UIView(frame: CGRect(x: 0, y: 0, width: 10, height: 10))
        view.backgroundColor = color
        return Row(text: name, accessory: Row.Accessory.View(view), selection: { [unowned self] in
          self.parentModule?.choosenColor(name, color)
        })
      })
    ]
  }
}