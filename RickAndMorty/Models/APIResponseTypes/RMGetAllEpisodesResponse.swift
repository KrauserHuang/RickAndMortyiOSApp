//
//  RMGetAllEpisodesResponse.swift
//  RickAndMorty
//
//  Created by Tai Chin Huang on 2023/5/20.
//

import Foundation

struct RMGetAllEpisodesResponse: Codable {
    struct Info: Codable {
        let count: Int
        let pages: Int
        let next: String?
        let prev: String?
    }
    let info: Info
    let results: [RMEpisode]
}
