//
//  RMLocation.swift
//  RickAndMorty
//
//  Created by Tai Chin Huang on 2023/2/26.
//

import Foundation

struct RMLocation: Codable {
    let id: Int
    let name: String
    let type: String
    let dimension: String
    let residents: [String]
    let url: String
    let created: String
}
