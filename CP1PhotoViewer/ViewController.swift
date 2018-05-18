//
//  ViewController.swift
//  CP1PhotoViewer
//
//  Created by g.shu on 2018/05/17.
//  Copyright © 2018 Yuan Zhou. All rights reserved.
//

import UIKit

/// Displays the photo viewer.
class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
    }
}

// MARK: - UICollectionViewDataSource, UICollectionViewDelegate
extension ViewController: UICollectionViewDataSource, UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        // TODO: change to the real photo numbers that is retrieved from an online photo viewer service
        return 100;
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        guard let photoCell = collectionView.dequeueReusableCell(withReuseIdentifier: "PhotoCell", for: indexPath) as? PhotoCell else {
            fatalError("The dequeued cell is not an instance of PhotoCell")
        }
        
        // TODO: implement the photoCell with the real photo data
        photoCell.photoImageView.backgroundColor = .gray
        
        return photoCell
    }
    
}
