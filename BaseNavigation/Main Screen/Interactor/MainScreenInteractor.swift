//
//  BaseNavigation
//
//  Created by Pavel Guzenko on 14.12.2021.
//

import Foundation

class MainScreenInteractor: MainScreenInteractorProtocol {
    private weak var presenter: MainScreenPresenterForInteractorProtocol? = nil

    //MARK: MainScreenInteractorProtocol
    required init(presenter: MainScreenPresenterForInteractorProtocol) {
        self.presenter = presenter
    }

    func loadDefaultData() {
        let entities: [MainScreenEntity] = [
            MainScreenEntity(id: 1, imageUrl: "https://i.picsum.photos/id/0/5616/3744.jpg?hmac=3GAAioiQziMGEtLbfrdbcoenXoWAW-zlyEAMkfEdBzQ", backgroundColor: .red),
            MainScreenEntity(id: 2, imageUrl: "https://i.picsum.photos/id/10/2500/1667.jpg?hmac=J04WWC_ebchx3WwzbM-Z4_KC_LeLBWr5LZMaAkWkF68", backgroundColor: .yellow),
            MainScreenEntity(id: 3, imageUrl: "https://i.picsum.photos/id/100/2500/1656.jpg?hmac=gWyN-7ZB32rkAjMhKXQgdHOIBRHyTSgzuOK6U0vXb1w", backgroundColor: .gray),
            MainScreenEntity(id: 4, imageUrl: "https://i.picsum.photos/id/1003/1181/1772.jpg?hmac=oN9fHMXiqe9Zq2RM6XT-RVZkojgPnECWwyEF1RvvTZk", backgroundColor: .green),
            MainScreenEntity(id: 5, imageUrl: "https://i.picsum.photos/id/1008/5616/3744.jpg?hmac=906z84ml4jhqPMsm4ObF9aZhCRC-t2S_Sy0RLvYWZwY", backgroundColor: .black),
            MainScreenEntity(id: 6, imageUrl: "https://i.picsum.photos/id/101/2621/1747.jpg?hmac=cu15YGotS0gIYdBbR1he5NtBLZAAY6aIY5AbORRAngs", backgroundColor: .brown)
        ]
        presenter?.showEntities(entities)
    }
}
