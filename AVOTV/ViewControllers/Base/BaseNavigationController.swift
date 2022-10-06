
import UIKit

class BaseNavigationController: UINavigationController {
    
    
    override var childForStatusBarStyle: UIViewController? {
        return visibleViewController
    }
    
    override func loadView() {
        super.loadView()
    }
    
    
}
