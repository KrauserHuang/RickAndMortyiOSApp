//
//  RMEpisodeViewController.swift
//  RickAndMorty
//
//  Created by Tai Chin Huang on 2023/2/26.
//

import UIKit

/// Controller to show and search for Episodes
final class RMEpisodeViewController: UIViewController {

    private let episodeListView = RMEpisodeListView()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "Episodes"
        view.backgroundColor = .systemBackground
        view.addSubview(episodeListView)
        episodeListView.delegate = self
        configureUI()
    }
    
    private func configureUI() {
        NSLayoutConstraint.activate([
            episodeListView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            episodeListView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            episodeListView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            episodeListView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
        ])
    }
}

// MARK: - RMEpisodeListViewDelegate

extension RMEpisodeViewController: RMEpisodeListViewDelegate {
    func rmEpisodeListView(_ episodeListView: RMEpisodeListView, didSelectEpisode episode: RMEpisode) {
        // Open detail controller for that episode
        let detailVC = RMEpisodeDetailViewController(url: URL(string:episode.url))
        detailVC.navigationItem.largeTitleDisplayMode = .never
        navigationController?.pushViewController(detailVC, animated: true)
    }
}
