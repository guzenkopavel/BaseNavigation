//
//  BaseNavigation
//
//  Created by Pavel Guzenko on 14.12.2021.
//

import Foundation

class MainScreenRouter: MainScreenRouterProtocol {
    private weak var view: MainScreenViewProtocol?

    required init(view: MainScreenViewProtocol) {
        self.view = view
    }
}
