//
//  RMEpisode.swift
//  RickAndMorty
//
//  Created by Tai Chin Huang on 2023/2/26.
//

import Foundation

struct RMEpisode: Codable {
    let id: Int
    let name: String
    let air_date: String
    let episode: String
    let characters: [String]
    let url: String
    let created: String
}
