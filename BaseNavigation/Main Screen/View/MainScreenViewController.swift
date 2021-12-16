//
//  BaseNavigation
//
//  Created by Pavel Guzenko on 14.12.2021.
//

import Foundation
import UIKit

class MainScreenViewController: UIViewController {
    // Create default VIPER screen configurator
    private var configurator: MainScreenConfiguratorProtocol = MainScreenConfigurator()
    // Create view for current viewController
    private var mainView: MainScreenViewProtocol = MainScreenView()

    // MARK: ViewController LifeCircle
    override func viewDidLoad() {
        super.viewDidLoad()
        view = mainView as? UIView
        configurator.configure(view: mainView)
    }
}
