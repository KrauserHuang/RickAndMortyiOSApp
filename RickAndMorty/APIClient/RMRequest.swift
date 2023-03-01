//
//  RMRequest.swift
//  RickAndMorty
//
//  Created by Tai Chin Huang on 2023/3/1.
//

import Foundation

/// Object that represents a singlet API call
final class RMRequest {
    /// API Constant
    private struct Constants {
        static let baseUrl = "https://rickandmortyapi.com/api"
    }
    
    /// Desired endpoint
    private let endpoint: RMEndpoint
    
    /// Path components for API, if any
    private let pathComponents: Set<String>
    
    /// Query arguments for API, if any
    private let queryParameters: [URLQueryItem]
    
    /// Constructed url for for the api request in string format(建立url字串格式) -> baseUrl + endpoint + pathComponents + queryParameters
    private var urlString: String {
        var string = Constants.baseUrl
        string += "/"
        string += endpoint.rawValue
        
        if !pathComponents.isEmpty {
            pathComponents.forEach { string += "/\($0)" }
        }
        
        if !queryParameters.isEmpty {
            string += "?"
            // name1=value1&name2=value2
            let argumentString = queryParameters.compactMap {
                guard let value = $0.value else { return nil }
                return "\($0.name)=\(value)"
            }.joined(separator: "&")
            
            string += argumentString
        }
        
        return string
    }
    
    /// Computed & constructed API url
    public var url: URL? {
        return URL(string: urlString)
    }
    
    /// Desired http method
    public let httpMethod = "GET"
    
    /*
     ex: https://rickandmortyapi.com/api/character/?name=rick&status=alive
     baseUrl = https://rickandmortyapi.com/api
     endpoint = character
     pathComponents -> 可能有也可能沒有
     queryParameters -> ["name": "rick", "status": "alive"]
     */
    
    // MARK: - Public
    /// Construct request
    /// - Parameters:
    ///   - endpoint: Target endpoint
    ///   - pathComponents: Collection of path components
    ///   - queryParamters: Collection of query parameters
    public init(endpoint: RMEndpoint, pathComponents: Set<String> = [], queryParamters: [URLQueryItem] = []) {
        self.endpoint = endpoint
        self.pathComponents = pathComponents
        self.queryParameters = queryParamters
    }
}
