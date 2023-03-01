//
//  RMCharacterViewController.swift
//  RickAndMorty
//
//  Created by Tai Chin Huang on 2023/2/26.
//

import UIKit

/// Controller to show and search for Characters
final class RMCharacterViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .systemBackground
        
        let request = RMRequest(
            endpoint: .character,
            queryParamters: [
                URLQueryItem(name: "name", value: "rick"),
                URLQueryItem(name: "status", value: "alive")
            ]
        )
        print(request.url)
        
//        RMService.shared.execute(request,
//                                 expecting: String.self) { result in
//            switch result {
//            case .success(<#T##String#>)
//            }
//        }
    }
}
