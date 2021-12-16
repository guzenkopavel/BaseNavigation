//
//  BaseNavigation
//
//  Created by Pavel Guzenko on 14.12.2021.
//

import Foundation
import UIKit

protocol MainScreenConfiguratorProtocol: AnyObject {
    // Basic method linking the VIPER logic between its elements
    // view: screen view
    func configure(view: MainScreenViewProtocol)
}

protocol MainScreenInteractorProtocol: AnyObject {
    init(presenter: MainScreenPresenterForInteractorProtocol)

    // Load base default data with 6 elements
    func loadDefaultData()
}

protocol MainScreenPresenterForViewProtocol: AnyObject {
    // Restore to default screen state, and load base 6 elements
    func restoreDefaultData()

    //
    func tapOnEntity(_ entity: MainScreenViewEntityProtocol)
}

protocol MainScreenPresenterForInteractorProtocol: AnyObject {
    func showEntities(_ entities: [MainScreenEntityProtocol])
}

protocol MainScreenPresenterProtocol: MainScreenPresenterForViewProtocol, MainScreenPresenterForInteractorProtocol {
    var router: MainScreenRouterProtocol? { set get }
    var interactor: MainScreenInteractorProtocol? { set get }
    init(view: MainScreenViewProtocol)
}

protocol MainScreenRouterProtocol: AnyObject {
    init(view: MainScreenViewProtocol)
}

protocol MainScreenViewProtocol: AnyObject {
    var presenter: MainScreenPresenterForViewProtocol? { set get }

    // Show viewModel on view
    // entities: models array, which need show
    func showEntities(_ entities: [MainScreenViewEntityProtocol])

    // Remove viewModel from view
    // entityID: entity id which need remove from view
    func removeEntityWithID(_ entityID: Int)

    // By default, entity cant be deleted, while canBeDeleted parameter set to false
    // entityID: entity id, which we must open for interaction
    func updateEntity(_ entity: MainScreenViewEntityProtocol)
}
