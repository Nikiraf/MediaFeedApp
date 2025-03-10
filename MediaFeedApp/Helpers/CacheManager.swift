//
//  CacheManager.swift
//  MedialFeedApp
//
//  Created by Aleksandar Nikolic on 9.3.25..
//

import Foundation
import UIKit

class ImageCacheManager {
    static let shared = ImageCacheManager()

    private init() {}

    private var cache = NSCache<NSString, UIImage>()
    
    private var fileManager = FileManager.default
    private var cacheDirectory: URL {
        let cachesDirectory = fileManager.urls(for: .cachesDirectory, in: .userDomainMask).first!
        let cacheDirectory = cachesDirectory.appendingPathComponent("ImageCache", isDirectory: true)
        
        if !fileManager.fileExists(atPath: cacheDirectory.path) {
            try? fileManager.createDirectory(at: cacheDirectory, withIntermediateDirectories: true)
        }
        
        return cacheDirectory
    }

    func cachedImage(for url: URL) -> UIImage? {
        if let cachedImage = cache.object(forKey: url.absoluteString as NSString) {
            return cachedImage
        }
        
        let cachedURL = cacheDirectory.appendingPathComponent(url.lastPathComponent)
        if let data = try? Data(contentsOf: cachedURL), let image = UIImage(data: data) {
            cache.setObject(image, forKey: url.absoluteString as NSString)
            return image
        }
        
        return nil
    }

    func cacheImage(_ image: UIImage, for url: URL) {
        cache.setObject(image, forKey: url.absoluteString as NSString)

        let cachedURL = cacheDirectory.appendingPathComponent(url.lastPathComponent)
        if let data = image.pngData() {
            try? data.write(to: cachedURL)
        }
    }

    func removeCachedImage(for url: URL) {
        cache.removeObject(forKey: url.absoluteString as NSString)

        let cachedURL = cacheDirectory.appendingPathComponent(url.lastPathComponent)
        try? FileManager.default.removeItem(at: cachedURL)
    }
}


class CacheManager {
    static let shared = CacheManager()
    
    private let imageCache = NSCache<NSString, UIImage>()
    private let videoCacheLimit: UInt64 = 500 * 1024 * 1024 // 500 MB Cache Limit
    
    private init() {}
    
    func getImage(for url: URL) -> UIImage? {
        return imageCache.object(forKey: url.absoluteString as NSString)
    }
    
    func cacheImage(_ image: UIImage, for url: URL) {
        imageCache.setObject(image, forKey: url.absoluteString as NSString)
    }
    
    func getVideoCacheDirectory() -> URL {
        let cachesDirectory = FileManager.default.urls(for: .cachesDirectory, in: .userDomainMask).first!
        let cacheDirectory = cachesDirectory.appendingPathComponent("VideoCache", isDirectory: true)
        
        if !FileManager.default.fileExists(atPath: cacheDirectory.path) {
            try? FileManager.default.createDirectory(at: cacheDirectory, withIntermediateDirectories: true)
        }
        
        return cacheDirectory
    }
    
    func cleanUpVideoCacheIfNeeded() {
        let cacheDirectory = getVideoCacheDirectory()
        let fileManager = FileManager.default

        guard let cachedFiles = try? fileManager.contentsOfDirectory(at: cacheDirectory, includingPropertiesForKeys: [.fileSizeKey, .creationDateKey], options: .skipsHiddenFiles) else { return }

        let totalCacheSize = cachedFiles.reduce(0) { total, fileURL in
            let fileSize = (try? fileManager.attributesOfItem(atPath: fileURL.path)[.size] as? UInt64) ?? 0
            return total + Int(fileSize)
        }

        guard totalCacheSize > videoCacheLimit else { return }

        let sortedFiles = cachedFiles.sorted { (url1, url2) -> Bool in
            let date1 = (try? fileManager.attributesOfItem(atPath: url1.path)[.creationDate] as? Date) ?? Date.distantPast
            let date2 = (try? fileManager.attributesOfItem(atPath: url2.path)[.creationDate] as? Date) ?? Date.distantPast
            return date1 < date2
        }

        var spaceToFree = totalCacheSize - Int(videoCacheLimit)
        for file in sortedFiles where spaceToFree > 0 {
            let fileSize = (try? fileManager.attributesOfItem(atPath: file.path)[.size] as? UInt64) ?? 0
            try? fileManager.removeItem(at: file)
            spaceToFree -= Int(fileSize)
        }
    }
    
    func getCachedVideoURL(for url: URL) -> URL? {
        let cacheDirectory = getVideoCacheDirectory()
        return cacheDirectory.appendingPathComponent(url.lastPathComponent)
    }
}
