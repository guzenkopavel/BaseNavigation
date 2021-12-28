//
// Created by Pavel Guzenko on 14.12.2021.
//

import Foundation
import UIKit

extension UIImageView {
    // The function allows you to load images asynchronously
    // value: link of image from internet
    // placeholderImage: default image, which will be displayed until you download a new one
    // complete: optional callback, returning the downloaded image or error, if complete is nil, image well be set as imageview.image value
    public func setImageUrl(_ value: String, placeholderImage: UIImage? = nil, complete: ((UIImage?, Error?, URL?) -> ())? = nil) {
        ImageService.shared.loadImageWithUrl(value) { image, error, url in
            if complete != nil {
                complete?(image, error, url)
            } else {
                self.image = image
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