//
//  BaseNavigation
//
//  Created by Pavel Guzenko on 14.12.2021.
//

import Foundation

class MainScreenPresenter: MainScreenPresenterProtocol {
    private weak var view: MainScreenViewProtocol? = nil

    // MARK: MainScreenPresenterProtocol
    var router: MainScreenRouterProtocol? = nil
    var interactor: MainScreenInteractorProtocol? = nil

    required init(view: MainScreenViewProtocol) {
        self.view = view
    }

    // MARK: MainScreenPresenterForViewProtocol
    func tapOnEntity(_ entity: MainScreenViewEntityProtocol) {
        if entity.canBeDeleted == true {
            view?.removeEntityWithID(entity.id)
        }
    }

    func restoreDefaultData() {
        interactor?.loadDefaultData()
    }

    // MARK: MainScreenPresenterForInteractorProtocol

    func showEntities(_ entities: [MainScreenEntityProtocol]) {
        view?.showEntities(entities.map { entity -> MainScreenViewEntity in
            MainScreenViewEntity(id: entity.id, imageUrl: entity.imageUrl, backgroundColor: entity.backgroundColor, delegate: self)
        })
    }
}

// MARK: MainScreenImageDownloadDelegate
extension MainScreenPresenter: MainScreenImageDownloadDelegate {
    func imageWasDownloadForEntity(_ entity: MainScreenViewEntityProtocol) {
        if entity.canBeDeleted == false {
            var newEntity = entity
            newEntity.canBeDeleted = true
            view?.updateEntity(newEntity)
        }
    }
}
