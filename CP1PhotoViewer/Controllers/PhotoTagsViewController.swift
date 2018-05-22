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
    
    /// Image to be analyzed so as to retrieve tags at Imagga
    var analyzingImage: UIImage?
    
    /// Tags that is retrieved from Imagga
    var tags = [String]()
    
    // MARK: - View Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()

        if let url = photoImageUrl {
            showLoadingHUD(view: photoImageView)
            photoImageView.af_setImage(withURL: url) { response in
                self.hideLoadingHUD(view: self.photoImageView)
            }
        } else {
            print("photo image url is unknown")
        }
        
        analyzeImageAndFetchTags {
            self.tagsTableView.reloadData()
        }
    }
    
    // MARK: File Private
    func analyzeImageAndFetchTags(completion: @escaping () -> Void) {
        if let image = analyzingImage {
            guard let imageData = UIImageJPEGRepresentation(image, 0.5) else {
                print("Could not get JPEG representation of UIImage")
                return
            }
            
            self.uploadAnalyzingImageData(imageData: imageData) { contentID in
                self.downloadTags(contentID: contentID, completion: { tags in
                    
                    self.hideLoadingHUD(view: self.tagsTableView)
                    
                    if let tags = tags {
                        self.tags = tags
                        
                        completion()
                    }
                })
            }
        } else {
            print("Could not get image")
        }
    }
    
    func uploadAnalyzingImageData(imageData:Data, completion: @escaping (String) -> Void) {
        
        showLoadingHUD(view: tagsTableView)
        
        Alamofire.upload(
            multipartFormData: { multipartFormData in
                multipartFormData.append(imageData,
                                         withName: "imagefile",
                                         fileName: "image.jpg",
                                         mimeType: "image/jpeg")
        }, with: ImaggaRouter.content)
        { encodingResult in
            switch encodingResult {
            case.success(let upload, _, _):
                upload.validate()
                upload.responseJSON(completionHandler: { response in
                    guard response.result.isSuccess, let value = response.result.value else {
                        print("Error while uploading file: \(String(describing: response.result.error))")
                        return
                    }
                    
                    let firstFileID = JSON(value)["uploaded"][0]["id"].stringValue
                    print("Content uploaded with ID: \(firstFileID)")
                    
                    completion(firstFileID)
                })
            case .failure(let encodingError):
                self.hideLoadingHUD(view: self.tagsTableView)
                print(encodingError)
            }
        }
    }
    
    func downloadTags(contentID: String, completion: @escaping ([String]?) -> Void) {
        Alamofire.request(ImaggaRouter.tags(contentID))
            .responseJSON { response in
                guard response.result.isSuccess, let value = response.result.value else {
                    print("Error while fetching tags: \(String(describing: response.result.error))")
                    return
                }
                
                let tags = JSON(value)["results"][0]["tags"].array?.map { json in
                    json["tag"].stringValue
                }
                
                completion(tags)
        }
    }
}

// MARK: - UITableViewDelegate, UITableViewDataSource
extension PhotoTagsViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.tags.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "TagsTableViewCell", for: indexPath)
        
        cell.textLabel?.text = self.tags[indexPath.item]
        
        return cell
    }
}
