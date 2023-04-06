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
    private let pathComponents: [String]
    
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
            
            string += argumentString //結果會變這樣：?name1=value1&name2=value2
        }
        
        return string
    }
    
    private var urlComponents: URLComponents {
        var components = URLComponents()
        components.scheme = "https"
        components.host = "rickandmortyapi.com"
        components.path = "api"
        return components
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
    public init(endpoint: RMEndpoint, pathComponents: [String] = [], queryParamters: [URLQueryItem] = []) {
        self.endpoint = endpoint
        self.pathComponents = pathComponents
        self.queryParameters = queryParamters
    }
    /// Attempt to create request
    /// - Parameter url: URL to parse
    convenience init?(url: URL) {
        let string = url.absoluteString
        if !string.contains(Constants.baseUrl) {
            return nil
        }
        print("string = \(string)")
        let trimmed = string.replacingOccurrences(of: Constants.baseUrl+"/", with: "")
        print("trimmed = \(trimmed)")
        if trimmed.contains("/") {
            let components = trimmed.components(separatedBy: "/")
            print("components = \(components)")
            if !components.isEmpty {
                let endpointString = components[0] // Endpoint = character -> path的路徑
                var pathComponents: [String] = []
                if components.count > 1 {
                    pathComponents = components // pathComponents = 1 -> 參數
                    pathComponents.removeFirst()
                    print("pathComponents = \(pathComponents)")
                }
                if let rmEnpoint = RMEndpoint(rawValue: endpointString) { // 取的路徑與參數，再把它做初始化
                    self.init(endpoint: rmEnpoint, pathComponents: pathComponents)
                    return
                }
            }
        } else if trimmed.contains("?") {
            let components = trimmed.components(separatedBy: "?")
            if !components.isEmpty, components.count >= 2 {
                let endpointString = components[0]
                let queryItemsString = components[1]
                //value=name&value=name
                let queryItems: [URLQueryItem] = queryItemsString.components(separatedBy: "&").compactMap {
                    guard $0.contains("=") else {
                        return nil
                    }
                    let parts = $0.components(separatedBy: "=")
                    
                    return URLQueryItem(name: parts[0], value: parts[1])
                }
                if let rmEnpoint = RMEndpoint(rawValue: endpointString) {
                    self.init(endpoint: rmEnpoint, queryParamters: queryItems)
                    return
                }
            }
        }
        return nil
    }
}

extension RMRequest {
    static let listCharatersRequests = RMRequest(endpoint: .character)
}
