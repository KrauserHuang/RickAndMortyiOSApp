//
//  RMService.swift
//  RickAndMorty
//
//  Created by Tai Chin Huang on 2023/3/1.
//

import Foundation

//command + option + / -> Add doc
/// Primary API service object to get RIck and Morty data
final class RMService {
    /// Shared singleton instance
    static let shared = RMService()
    
    /// Privatized constructor
    private init() {}
    
    /// Send Rick and Morty API call
    /// - Parameters:
    ///   - request: Request instance
    ///   - completion: Callback with data or error
    public func execute<T: Codable>(_ request: RMRequest,
                                    expecting type: T.Type,
                                    completion: @escaping (Result<T, Error>) -> Void) {
        
    }
}
