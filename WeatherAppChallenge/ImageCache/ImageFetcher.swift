//
//  ImageFetcher.swift
//  WeatherAppChallenge
//
//  Created by Venkata Sravani Motamarri on 8/29/24.
//

import Foundation
import SwiftUI

protocol ImageCache {
    func image(for iconName: String) -> Image?
    func addImageToCache(_ image: Image,for iconName: String) -> Image
}

final class ImageFetcher: ImageCache {
   
    static let shared = ImageFetcher()
    
    private let lock = NSLock()
    
    lazy var cache: NSCache<AnyObject, AnyObject> = {
        let cache = NSCache<AnyObject, AnyObject>()
        cache.countLimit = 100
        return cache
    }()
    
    
    /// Image func is get the image from API
    /// - Parameter iconName: Weather icon name from API
    /// - Returns: Image associated with iconName from cache if available
    func image(for iconName: String) -> Image? {
        guard let cachedImage = cache.object(forKey: iconName as AnyObject) else {
            return nil
        }
        
        return cachedImage as? Image
    }
    
    /// Add Image to NSCache memory
    /// - Parameters:
    ///   - image: Image to be added for cache
    ///   - iconName: icon Name associate with the image
    /// - Returns: image that is added to the cache
    func addImageToCache(_ image: Image, for iconName: String) -> Image {
        lock.lock()

        defer {
            lock.unlock()
        }
        cache.setObject(image as AnyObject, forKey: iconName as AnyObject)
        return image
    }
}
