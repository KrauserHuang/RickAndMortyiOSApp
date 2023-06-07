//
//  RMEpisodeListView.swift
//  RickAndMorty
//
//  Created by Tai Chin Huang on 2023/4/15.
//

import UIKit

protocol RMEpisodeListViewDelegate: AnyObject {
    func rmEpisodeListView(_ episodeListView: RMEpisodeListView,
                             didSelectEpisode episode: RMEpisode)
}

/// View that handles showing list of episodes, loader, etc...
final class RMEpisodeListView: UIView {
    
    private let viewModel = RMEpisodeListViewViewModel()
    
    public weak var delegate: RMEpisodeListViewDelegate?
    
    private let spinner: UIActivityIndicatorView = { // anonymous closure
        let spinner = UIActivityIndicatorView(style: .large)
        spinner.hidesWhenStopped = true
        spinner.translatesAutoresizingMaskIntoConstraints = false
        return spinner
    }()
    
    private let collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        layout.sectionInset = UIEdgeInsets(top: 0, left: 10, bottom: 10, right: 10)
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.isHidden = true
        collectionView.alpha = 0
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.register(RMCharacterEpisodeCollectionViewCell.self,
                                forCellWithReuseIdentifier: RMCharacterEpisodeCollectionViewCell.reuseIdentifier)
        collectionView.register(RMFooterLoadingCollectionReusableView.self,
                                forSupplementaryViewOfKind: UICollectionView.elementKindSectionFooter,
                                withReuseIdentifier: RMFooterLoadingCollectionReusableView.reuseIdentifier)
        return collectionView
    }()
    
    // MARK: - Init
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        configure()
        viewModel.delegate = self
        viewModel.fetchEpisodes()
        setupCollectionView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // Some basic UI setup
    private func configure() {
        translatesAutoresizingMaskIntoConstraints = false
        
        addSubviews(collectionView, spinner)
        
        NSLayoutConstraint.activate([
            spinner.widthAnchor.constraint(equalToConstant: 100),
            spinner.heightAnchor.constraint(equalToConstant: 100),
            spinner.centerXAnchor.constraint(equalTo: centerXAnchor),
            spinner.centerYAnchor.constraint(equalTo: centerYAnchor),
            
            collectionView.topAnchor.constraint(equalTo: topAnchor),
            collectionView.leadingAnchor.constraint(equalTo: leadingAnchor),
            collectionView.trailingAnchor.constraint(equalTo: trailingAnchor),
            collectionView.bottomAnchor.constraint(equalTo: bottomAnchor),
        ])
        
        spinner.startAnimating()
    }
    
    private func setupCollectionView() {
        // 可以把view當作collectionView的delegate/dataSource或者把這個工作交給viewModel來做
        collectionView.dataSource = viewModel
        collectionView.delegate = viewModel
    }
}

extension RMEpisodeListView: RMEpisodeListViewViewModelDelegate {
    func didLoadInitialEpisode() {
        spinner.stopAnimating()
        collectionView.isHidden = false
        collectionView.reloadData()
        
        UIView.animate(withDuration: 0.4, delay: 0.2) {
            self.collectionView.alpha = 1
        }
    }
    
    func didSelectEpisode(_ episode: RMEpisode) {
        delegate?.rmEpisodeListView(self, didSelectEpisode: episode)
    }
    
    func didLoadMoreEpisodes(with newIndexPaths: [IndexPath]) {
        collectionView.performBatchUpdates {
            collectionView.insertItems(at: newIndexPaths)
        }
    }
}
