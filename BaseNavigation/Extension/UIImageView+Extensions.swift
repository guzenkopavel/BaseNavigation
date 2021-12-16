//
// Created by Pavel Guzenko on 14.12.2021.
//

import Foundation
import UIKit

extension UIImageView {
    // The function allows you to load images asynchronously
    // value: link of image from internet
    // placeholderImage: default image, which will be displayed until you download a new one
    // complete: optional callback, returning the downloaded image or error
    public func setImageUrl(_ value: String, placeholderImage: UIImage? = nil, complete: ((UIImage?, Error?) -> ())? = nil) {
        ImageService.shared.loadImageWithUrl(value) { image, error in
            self.image = image
            if complete != nil {
                complete?(image, error)
            }
        }
    }

    // Before making a new image request to ImageView, it is worth canceling the previous one so that when reusing,
    // there is no competition of requests
    // value: imageUrl for previous request
    public func cancelImageLoad(_ value: String) {
        ImageService.shared.cancelImageLoad(value)
    }
}