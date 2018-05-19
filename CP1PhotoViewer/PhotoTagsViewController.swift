//
//  PhotoTagsViewController.swift
//  CP1PhotoViewer
//
//  Created by g.shu on 2018/05/19.
//  Copyright © 2018 Yuan Zhou. All rights reserved.
//

import UIKit
import Alamofire
import AlamofireImage
import SwiftyJSON

/// Display a user-choosen photo in a 16:9 rectangle view and tags related to the photo's content
class PhotoTagsViewController: UIViewController {
    
    // MARK: - IBOutlet
    @IBOutlet weak var photoImageView: UIImageView!
    @IBOutlet weak var tagsTableView: UITableView!
    
    // MARK: - Properties
    /// Image URL as displayed upside of the scene
    var photoImageUrl: URL?
    
    // MARK: - View Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()

        if let url = photoImageUrl {
            photoImageView.af_setImage(withURL: url)
        } else {
            print("photo image url is unknown")
        }
    }
}

// MARK: - UITableViewDelegate, UITableViewDataSource
extension PhotoTagsViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // TODO: implement with real tags number
        return 20
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "TagsTableViewCell", for: indexPath)
        
        // TODO: implement with real tags
        cell.textLabel?.text = "dummy tag No.\(indexPath.item)"
        
        return cell
    }
}
