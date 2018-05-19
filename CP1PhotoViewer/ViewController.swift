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
    var squarePhotos = [String]()
    var rectPhotos = [String]()

    // MARK: - View Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        getPhotos()
    }
    
    // MARK: - Navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "ShowPhotoTags",
            let controller = segue.destination as? PhotoTagsViewController {
            
            guard let collectionCell = sender as? PhotoCell else {
                fatalError("The selected cell is not PhotoCell")
            }
            
            if let indexPath = collectionView.indexPath(for: collectionCell) {
                controller.photoImageUrl = URL(string: rectPhotos[indexPath.item])
            }
        }
    }
    
    // MARK: - File Private
    fileprivate func getPhotos() {
        Alamofire.request(FlickrRouter.rest)
            .responseJSON { response in
                guard response.result.isSuccess, let value = response.result.value else {
                    print("Error while fetching photos: \(String(describing: response.result.error))")
                    return
                }
                
                let squarePhotos = JSON(value)["photos"]["photo"].array?.map { json in
                    json["url_q"].stringValue
                }
                let rectPhotos = JSON(value)["photos"]["photo"].array?.map { json in
                    json["url_z"].stringValue
                }
                
                if let squarePhotos = squarePhotos, let rectPhotos = rectPhotos {
                    self.squarePhotos = squarePhotos
                    self.rectPhotos = rectPhotos
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
        return self.squarePhotos.count;
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        guard let photoCell = collectionView.dequeueReusableCell(withReuseIdentifier: "PhotoCell", for: indexPath) as? PhotoCell else {
            fatalError("The dequeued cell is not an instance of PhotoCell")
        }
        
        if let url = URL(string: self.squarePhotos[indexPath.item]) {
            photoCell.photoImageView.af_setImage(withURL: url)
        } else {
            print("Nil url cannot be initialized as a photo")
        }
        
        return photoCell
    }
}
