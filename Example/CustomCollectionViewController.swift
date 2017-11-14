//
//  CustomCollectionViewController.swift
//  Example
//
//  Created by 鈴木 俊裕 on 2017/11/14.
//  Copyright © 2017 toshi0383. All rights reserved.
//

import UIKit

class CustomCollectionViewController: UIViewController, UICollectionViewDataSource {
    @IBOutlet private weak var collectionView: UICollectionView! {
        didSet {
            collectionView.dataSource = self
        }
    }
    private let items: [Int] = (0..<1000).map { $0 }
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return items.count
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "Cell", for: indexPath) as! CollectionViewCell
        cell.configure(indexPath: indexPath)
        return cell
    }
}

