//
//  RMEndpoint.swift
//  RickAndMorty
//
//  Created by Tai Chin Huang on 2023/3/1.
//

import Foundation

// TODO: 之後影片會說明此處為何用 @frozen
/// Represent unique API endpoint
@frozen enum RMEndpoint: String, Hashable, CaseIterable { //rawValue type of String, ex: RMEndpoint.character.rawValue = "character"(可以直接取的其case字眼)
    /// Endpoint to get character info
    case character
    /// Endpoint to get location info
    case location
    /// Endpoint to get episode info
    case episode
}
