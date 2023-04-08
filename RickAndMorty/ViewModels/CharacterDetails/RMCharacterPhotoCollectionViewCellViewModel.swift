//
//  RMCharacterPhotoCollectionViewCellViewModel.swift
//  RickAndMorty
//
//  Created by Tai Chin Huang on 2023/4/6.
//

import Foundation

final class RMCharacterPhotoCollectionViewCellViewModel {
    
    public let imageUrl: URL?
    
    init(imageUrl: URL?) {
        self.imageUrl = imageUrl
    }
    
    public func fetchImage(completion: @escaping (Result<Data, Error>) -> Void) {
        guard let imageUrl = imageUrl else { return }
        RMImageLoader.shared.downloadImage(imageUrl, completion: completion)
    }
}
