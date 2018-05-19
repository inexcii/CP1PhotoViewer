//
//  ViewController.swift
//  CP1PhotoViewer
//
//  Created by g.shu on 2018/05/17.
//  Copyright © 2018 Yuan Zhou. All rights reserved.
//

import UIKit
import Alamofire
import AlamofireImage
import SwiftyJSON

/// Displays the photo viewer.
class ViewController: UIViewController {
    
    // MARK: - IBOutlet
    @IBOutlet var collectionView: UICollectionView!
    
    // MARK: - Properties
    var photos = [String]()

    // MARK: - View Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        getPhotos()
    }
    
    // MARK: - File Private
    fileprivate func getPhotos() {
        Alamofire.request(FlickrRouter.rest)
            .responseJSON { response in
                guard response.result.isSuccess, let value = response.result.value else {
                    print("Error while fetching photos: \(String(describing: response.result.error))")
                    return
                }
                
                let photos = JSON(value)["photos"]["photo"].array?.map { json in
                    json["url_q"].stringValue
                }
                
                if let photos = photos {
                    self.photos = photos
                    self.collectionView.reloadData()
                } else {
                    print("photos do not contain any data")
                }
        }
    }
}

// MARK: - UICollectionViewDataSource, UICollectionViewDelegate
extension ViewController: UICollectionViewDataSource, UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.photos.count;
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        guard let photoCell = collectionView.dequeueReusableCell(withReuseIdentifier: "PhotoCell", for: indexPath) as? PhotoCell else {
            fatalError("The dequeued cell is not an instance of PhotoCell")
        }
        
        if let url = URL(string: self.photos[indexPath.item]) {
            photoCell.photoImageView.af_setImage(withURL: url)
        } else {
            print("Nil url cannot be initialized as a photo")
        }
        
        return photoCell
    }
}
