//
//  RMGetAllCharactersResponse.swift
//  RickAndMorty
//
//  Created by Tai Chin Huang on 2023/3/2.
//

import Foundation

struct RMAllCharactersResponse: Codable {
    struct Info: Codable {
        let count: Int
        let pages: Int
        let next: String?
        let prev: String?
    }
    let info: Info
    let results: [RMCharacter]
}
