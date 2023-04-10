//
//  RMAPICacheManager.swift
//  RickAndMorty
//
//  Created by Tai Chin Huang on 2023/4/8.
//

import Foundation

/// Manages in memory session scoped API caches
final class RMAPICacheManager {
    // API URL: Data
    
    private var cacheDictionary: [RMEndpoint: NSCache<NSString, NSData>] = [:]
    
    init() {
        setupCache()
    }
    
    // MARK: - Public
    
    /// 確認cacheResponse
    /// - Parameters:
    ///   - endpoint: endpoint類別
    ///   - url: url
    /// - Returns: cache裡儲存的data
    public func cachedResponse(for endpoint: RMEndpoint, url: URL?) -> Data? {
        guard let targetCache = cacheDictionary[endpoint], let url = url else {
            return nil
        }
        let key = url.absoluteString as NSString // url作為cache的key (非cacheDictionary的key，是NSCache的key)
        return targetCache.object(forKey: key) as? Data
    }
    
    public func setCache(for endpoint: RMEndpoint, url: URL?, data: Data) {
        guard let targetCache = cacheDictionary[endpoint], let url = url else {
            return
        }
        let key = url.absoluteString as NSString // url作為cache的key (非cacheDictionary的key，是NSCache的key)
        targetCache.setObject(data as NSData, forKey: key)
    }
    
    // MARK: - Private
    
    /// 初始化cache，對每個 endpoint (key) 類別放入空的NSCache
    private func setupCache() {
        RMEndpoint.allCases.forEach { endpoint in
            cacheDictionary[endpoint] = NSCache<NSString, NSData>()
        }
    }
}
