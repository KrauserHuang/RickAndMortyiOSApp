//
//  RMEpisodeDetailViewController.swift
//  RickAndMorty
//
//  Created by Tai Chin Huang on 2023/4/8.
//

import UIKit

/// VC to show detail about single episode
class RMEpisodeDetailViewController: UIViewController {
    
    private let url: URL?
    
    // MARK: - Init
    
    init(url: URL?) {
        self.url = url
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Life cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "Episode"
        view.backgroundColor = .systemGreen
    }
}
