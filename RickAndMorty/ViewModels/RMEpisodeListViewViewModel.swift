//
//  RMEpisodeListViewViewModel.swift
//  RickAndMorty
//
//  Created by Tai Chin Huang on 2023/4/15.
//

import UIKit

protocol RMEpisodeListViewViewModelDelegate: AnyObject {
    func didLoadInitialEpisode()
    func didSelectEpisode(_ episode: RMEpisode)
    func didLoadMoreEpisodes(with newIndexPaths: [IndexPath])
}

/// View Model to handle episode list view logic
final class RMEpisodeListViewViewModel: NSObject {
    
    public weak var delegate: RMEpisodeListViewViewModelDelegate?
    
    private var isLoadingMoreEpisodes = false
    
    private var apiInfo: RMGetAllEpisodesResponse.Info? = nil
    
    private let borderColors: [UIColor] = [
        .systemGreen,
        .systemBlue,
        .systemOrange,
        .systemPink,
        .systemPurple,
        .systemRed,
        .systemYellow,
        .systemIndigo,
        .systemMint
    ]
    
    private var episodes: [RMEpisode] = [] {
        didSet {
            for episode in episodes {
                let viewModel = RMCharacterEpisodeCollectionViewCellViewModel(
                    episodeDataUrl: URL(string: episode.url),
                    borderColor: borderColors.randomElement() ?? .systemBlue
                )
                if !cellViewModels.contains(viewModel) {
                    cellViewModels.append(viewModel)
                }
            }
        }
    }
    
    private var cellViewModels: [RMCharacterEpisodeCollectionViewCellViewModel] = []
    
    public func fetchEpisodes() {
        RMService.shared.execute(.listEpisodesRequests,
                                 expecting: RMGetAllEpisodesResponse.self) { [weak self] result in
            switch result {
            case .success(let responseModel):
                let results = responseModel.results
                let info = responseModel.info
                self?.apiInfo = info
                self?.episodes = results
                DispatchQueue.main.async {
                    self?.delegate?.didLoadInitialEpisode()
                }
            case .failure(let error):
                print("錯誤")
                print(String(describing: error))
            }
        }
    }
    
    //處理抓取角色動作
    public func fetchAdditionalCharacters(url: URL) { // -> 更新url來抓第二層角色
        guard !isLoadingMoreEpisodes else {
            return
        }
        isLoadingMoreEpisodes = true
        guard let request = RMRequest(url: url) else {
            isLoadingMoreEpisodes = false
            return
        }
        RMService.shared.execute(request,
                                 expecting: RMGetAllEpisodesResponse.self) { [weak self] result in
            guard let self else { return }
            switch result {
            case .success(let responseModel):
                let moreResults = responseModel.results
                let info = responseModel.info
                self.apiInfo = info
                
                let originalCount = self.episodes.count // -> 拿到舊的數量
                let newCount = moreResults.count // 抓到新的數量
                let startingIndex = originalCount
                let indexPathsToAdd: [IndexPath] = Array(startingIndex..<(startingIndex+newCount)).compactMap {
                    return IndexPath(row: $0, section: 0)
                }
                
                self.episodes.append(contentsOf: moreResults)
                DispatchQueue.main.async {
                    self.delegate?.didLoadMoreEpisodes(with: indexPathsToAdd)
                    self.isLoadingMoreEpisodes = false
                }
            case .failure(let failure):
                print(String(describing: failure))
                self.isLoadingMoreEpisodes = false
            }
        }
    }
    public var shouldShowLoadMoreIndicator: Bool {
        return apiInfo?.next != nil
    }
}
// MARK: - ViewModel handles collectionView delegate/dataSource
extension RMEpisodeListViewViewModel: UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return cellViewModels.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: RMCharacterEpisodeCollectionViewCell.reuseIdentifier, for: indexPath) as? RMCharacterEpisodeCollectionViewCell
        else { fatalError("Unsupported cell") }
        
        let viewModel = cellViewModels[indexPath.row]
        cell.configure(with: viewModel)
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let bounds = collectionView.bounds
        let width = bounds.width-20
        
        return CGSize(width: width,
                      height: 100)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        collectionView.deselectItem(at: indexPath, animated: true)
        let collection = episodes[indexPath.item]
        delegate?.didSelectEpisode(collection)
    }
    
    //建立collectionView的supplementaryView，這裡拿來建立其footer
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        
        guard kind == UICollectionView.elementKindSectionFooter,
              let footer = collectionView.dequeueReusableSupplementaryView(ofKind: kind,
                                                                           withReuseIdentifier: RMFooterLoadingCollectionReusableView.reuseIdentifier,
                                                                           for: indexPath) as? RMFooterLoadingCollectionReusableView else {
            fatalError("Unsuppoerted")
        }
        footer.startAnimating()
        return footer
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForFooterInSection section: Int) -> CGSize {
        guard shouldShowLoadMoreIndicator else {
            return .zero
        }
        return CGSize(width: collectionView.frame.width, height: 100)
    }
}

extension RMEpisodeListViewViewModel: UIScrollViewDelegate {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        guard shouldShowLoadMoreIndicator,
              !isLoadingMoreEpisodes,
              !cellViewModels.isEmpty,
              let nextUrlString = apiInfo?.next,
              let url = URL(string: nextUrlString) else { return }
        
//        print("Offset:\(offset)")
//        print("totalContentHeight:\(totalContentHeight)")
//        print("totalScrollViewFixedHeight:\(totalScrollViewFixedHeight)")
        
        Timer.scheduledTimer(withTimeInterval: 0.2, repeats: false) { [weak self] t in // -> 拉到底才會執行
            let offset = scrollView.contentOffset.y
            let totalContentHeight = scrollView.contentSize.height
            let totalScrollViewFixedHeight = scrollView.frame.size.height
            
            if offset >= (totalContentHeight - totalScrollViewFixedHeight - 120) {
                print("Should start fetching more")
                self?.fetchAdditionalCharacters(url: url)
            }
            t.invalidate() // -> clean your self up
        }
    }
}

