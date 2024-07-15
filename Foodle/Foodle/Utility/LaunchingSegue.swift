import UIKit

class LaunchingSegue: UIStoryboardSegue {
    override func perform(){
        guard let window = source.view.window else {return}
        
        window.rootViewController = destination
        
        UIView.transition(with: window, duration: 0.3, options: [.transitionCrossDissolve], animations: nil)
    }
}
