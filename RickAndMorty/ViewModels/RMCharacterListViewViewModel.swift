//
//  RMCharacterListViewViewModel.swift
//  RickAndMorty
//
//  Created by Tai Chin Huang on 2023/3/4.
//

import UIKit

final class RMCharacterListViewViewModel: NSObject {
    
    func fetchCharacters() {
        RMService.shared.execute(.listCharatersRequests,
                                 expecting: RMAllCharactersResponse.self) { result in
            switch result {
            case .success(let model):
                print("Example image url: " + String(model.results.first?.image ?? "No image"))
            case .failure(let error):
                print(String(describing: error))
            }
        }
    }
}
// MARK: - ViewModel handles collectionView delegate/dataSource
extension RMCharacterListViewViewModel: UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 20
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: RMCharacterCollectionViewCell.reuseIdentifier, for: indexPath) as? RMCharacterCollectionViewCell
        else { fatalError("Unsupported cell") }
        
        let viewModel = RMCharacterCollectionViewCellViewModel(characterName: "AAA",
                                                               characterStatus: .alive,
                                                               characterImageURL: URL(string: "https://rickandmortyapi.com/api/character/avatar/1.jpeg"))
        cell.configure(with: viewModel)
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let bounds = UIScreen.main.bounds
        let width = (bounds.width-30)/2
        
        return CGSize(width: width,
                      height: width * 1.5)
    }
}
