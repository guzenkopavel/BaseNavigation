//
//  BaseNavigation
//
//  Created by Pavel Guzenko on 14.12.2021.
//
import Foundation

class MainScreenConfigurator: MainScreenConfiguratorProtocol {
    func configure(view: MainScreenViewProtocol) {
        let presenter = MainScreenPresenter(view: view)
        let interactor = MainScreenInteractor(presenter: presenter)
        let router = MainScreenRouter(view: view)

        presenter.interactor = interactor
        presenter.router = router

        view.presenter = presenter

        // After we create links between modules, start show elements
        interactor.loadDefaultData()
    }
}
