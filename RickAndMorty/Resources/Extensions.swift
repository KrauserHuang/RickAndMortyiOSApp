//
//  Extensions.swift
//  RickAndMorty
//
//  Created by Tai Chin Huang on 2023/3/4.
//

import UIKit

extension UIView {
    func addSubviews(_ views: UIView...) { // variadic parameters
        views.forEach {
            addSubview($0)
        }
    }
}

protocol ReuseIdentifiable {
    static var reuseIdentifier: String { get }
}

extension ReuseIdentifiable {
    static var reuseIdentifier: String {
        return String(describing: self)
    }
}

extension UICollectionReusableView: ReuseIdentifiable {}
