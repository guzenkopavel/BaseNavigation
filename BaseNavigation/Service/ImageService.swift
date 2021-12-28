//
// Created by Pavel Guzenko on 15.12.2021.
//

import Foundation
import UIKit

enum ImageError: Error {
    case wrongUrl
    case wrongImageData
}

protocol ImageDownload {
    // In order to get away from the error when we request an image several times,
    // before trying to upload a new one, it is worth stopping the operation using the old one
    // url: link to cancel the operation
    func cancelImageLoad(_ url: String)

    // Load image by url from internet
    // url: Internet url with http or https
    // useCache: if true, response will be cached
    // callback:
    func loadImageWithUrl(_ url: String, useCache: Bool, callback: @escaping (UIImage?, Error?, URL?) -> ())
}

final class ImageService: ImageDownload {
    // Create queue for image download
    private let queue = DispatchQueue(label: "ImageService.main", qos: .background, attributes: .concurrent)
    // Array of tokens, for canceled image operation
    private var tokensForCancel: ThreadSafeArray<URLSessionDataTask> = ThreadSafeArray<URLSessionDataTask>()
    // Image cache, for store image after download
    private let cache = ImageCache()

    // Create single instance, for use single image cache for all image download operation
    static let shared: ImageService = {
        let service = ImageService()
        return service
    }()

    // MARK: ImageDownload protocol

    func cancelImageLoad(_ url: String) {
        // Find index by url
        var index: Int?
        for i in 0..<tokensForCancel.count {
            if tokensForCancel[i].currentRequest?.url?.absoluteString == url {
                index = i
                break
            }
        }

        // Get Task from array, cancel it and remove from store
        if let index = index {
            let task = tokensForCancel[index]
            task.cancel()
            tokensForCancel.removeAtIndex(index: index)
        }
    }

    func loadImageWithUrl(_ url: String, useCache: Bool = true, callback: @escaping (UIImage?, Error?, URL?) -> ()) {
        let item = DispatchWorkItem {
            // Check url is valid
            guard let imageUrl = URL(string: url) else {
                self.callBackDataForUrl(url) {
                    callback(nil, ImageError.wrongUrl, nil)
                }
                return
            }
            // Check image on cache, than useCache flag enabled
            if useCache == true, let image = self.cache.image(for: imageUrl) {
                self.callBackDataForUrl(url) {
                    callback(image, nil, imageUrl)
                }
                return
            }
            // Download image data from web
            let task = URLSession.shared.dataTask(with: imageUrl) { [weak self] data, response, error in
                // Check for internet and error
                if let error = error {
                    self?.callBackDataForUrl(url) {
                        callback(nil, error, imageUrl)
                    }
                    return
                }

                // Create from data image
                guard let data = data, let image = UIImage(data: data) else {
                    self?.callBackDataForUrl(url) {
                        callback(nil, ImageError.wrongImageData, imageUrl)
                    }
                    return
                }
                // If cache enabled, store image
                if useCache == true {
                    self?.cache.insertImage(image, for: imageUrl)
                }
                // Return downloaded image
                self?.callBackDataForUrl(url) {
                    callback(image, nil, imageUrl)
                }
            }
            task.resume()
        }
        queue.async(execute: item)
    }

    // MARK: Private func

    // After each operation, before returning the callback,
    // you need to delete the task from the storage, and return the data in the main stream
    private func callBackDataForUrl(_ url: String, callback: @escaping () -> ()) {
        cancelImageLoad(url)
        DispatchQueue.main.sync {
            callback()
        }
    }
}