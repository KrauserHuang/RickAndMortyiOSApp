//
//  RMCharacterDetailViewViewModel.swift
//  RickAndMorty
//
//  Created by Tai Chin Huang on 2023/3/6.
//

import Foundation

final class RMCharacterDetailViewViewModel {
    
    private let character: RMCharacter
    
    init(character: RMCharacter) {
        self.character = character
    }
    
    public var title: String {
        return character.name
    }
}
