//
//  RMCharacterEpisodeCollectionViewCellViewModel.swift
//  RickAndMorty
//
//  Created by Tai Chin Huang on 2023/4/6.
//

import UIKit

protocol RMEpisodeDataRender {
    var name: String { get }
    var air_date: String { get }
    var episode: String { get }
}

final class RMCharacterEpisodeCollectionViewCellViewModel: Hashable, Equatable {
    
    private let episodeDataUrl: URL?
    private var isFetching = false
    private var dataBlock: ((RMEpisodeDataRender) -> Void)?
    
    public let borderColor: UIColor
    
    private var episode: RMEpisode? {
        didSet {
            guard let model = episode else { return }
            dataBlock?(model)
        }
    }
    
    
    // MARK: - Init
    
    init(episodeDataUrl: URL?, borderColor: UIColor = .systemBlue) {
        self.episodeDataUrl = episodeDataUrl
        self.borderColor = borderColor
    }
    
    // MARK: - Public
    
    public func registerForData(_ block: @escaping (RMEpisodeDataRender) -> Void) {
        self.dataBlock = block
    }
    
    /*
     因為回傳的是url，必須
     */
    public func fetchEpisode() {
        guard !isFetching else {
            if let model = episode {
                dataBlock?(model)
            }
            return
        }
        guard let url = episodeDataUrl,
              let request = RMRequest(url: url) else { return }
        
        isFetching = true
        
        RMService.shared.execute(request,
                                 expecting: RMEpisode.self) { [weak self] result in
            guard let self else { return }
            switch result {
            case .success(let model):
                DispatchQueue.main.async {
                   self.episode = model
                }
            case .failure(let failure):
                print(String(describing: failure))
            }
        }
    }
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(self.episodeDataUrl?.absoluteString ?? "")
    }
    
    static func == (lhs: RMCharacterEpisodeCollectionViewCellViewModel, rhs: RMCharacterEpisodeCollectionViewCellViewModel) -> Bool {
        return lhs.hashValue == rhs.hashValue
    }
}
