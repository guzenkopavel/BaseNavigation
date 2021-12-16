//
// Created by Pavel Guzenko on 14.12.2021.
//

import Foundation
import UIKit

protocol MainScreenEntityProtocol {
    // Entity id, must be unique
    var id: Int { set get }
    // Link to image, must be higher than 800х600
    var imageUrl: String { set get }
    // Test backgroundColor for view, on which was showed
    var backgroundColor: UIColor { set get }
}

struct MainScreenEntity: MainScreenEntityProtocol {
    var id: Int
    var imageUrl: String
    var backgroundColor: UIColor
}

protocol MainScreenImageDownloadDelegate: AnyObject {
    // Function called after image was download
    // value: Entity, for which image was downloaded
    func imageWasDownloadForEntity(_ value: MainScreenViewEntityProtocol)
}

protocol MainScreenViewEntityProtocol {
    // Entity id, must be unique
    var id: Int { set get }
    // Link to image, must be higher than 800х600
    var imageUrl: String { set get }
    // Test backgroundColor for view, on which was showed
    var backgroundColor: UIColor { set get }
    // Flag whether the view can be deleted when the user clicks on it
    var canBeDeleted: Bool { set get }
    // Delegate for image download progress
    var delegate: MainScreenImageDownloadDelegate? { set get }
}

struct MainScreenViewEntity: MainScreenViewEntityProtocol {
    var id: Int
    var imageUrl: String
    var backgroundColor: UIColor
    weak var delegate: MainScreenImageDownloadDelegate? = nil
    var canBeDeleted: Bool = false
}