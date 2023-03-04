//
//  RMCharacterViewController.swift
//  RickAndMorty
//
//  Created by Tai Chin Huang on 2023/2/26.
//

import UIKit

/*
 把網路抓取層移到ViewModel
 */

/// Controller to show and search for Characters
final class RMCharacterViewController: UIViewController {
    
    private let characterListView = RMCharacterListView()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .systemBackground
        view.addSubview(characterListView)
        
        configureUI()
        
//        let request = RMRequest(
//            endpoint: .character,
//            queryParamters: [
//                URLQueryItem(name: "name", value: "rick"),
//                URLQueryItem(name: "status", value: "alive")
//            ]
//        )
////        print(request.url)
//        
//        RMService.shared.execute(request,
//                                 expecting: RMCharater.self.self) { result in
//            switch result {
//            case .success:
//                break
//            case .failure(let error):
//                print(String(describing: error))
//            }
//        }
    }
    
    private func configureUI() {
        NSLayoutConstraint.activate([
            characterListView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            characterListView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            characterListView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            characterListView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
        ])
    }
}
