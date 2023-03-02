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
        
        RMService.shared.execute(.listCharatersRequests,
                                 expecting: RMAllCharactersResponse.self) { result in
            switch result {
            case .success(let model):
                print("Total: " + String(model.info.count))
                print("Page result count: " + String(model.results.count))
            case .failure(let error):
                print(String(describing: error))
            }
        }
    }
}
