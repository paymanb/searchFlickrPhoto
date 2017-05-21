//
//  ViewController.swift
//  Photo Search
//
//  Created by Payman Bayat on 2/23/1396 AP.
//  Copyright © 1396 AP Payman Bayat. All rights reserved.
//

import UIKit
import Alamofire


class ViewController: UIViewController,UISearchBarDelegate {
    
    @IBOutlet weak var scrollView: UIScrollView!
    
    
    let requestURL = "https://api.flickr.com/services/rest/"

    override func viewDidLoad() {
        super.viewDidLoad()
        
        searchFlickrBy(searchString: "dog")
     
    }
    
    func searchFlickrBy(searchString : String) {
        
        let searchParameters:[String:Any] = ["method": "flickr.photos.search",
                                             "api_key": "3d95bb9bdd617f1039b676642b212bdf",
                                             "format": "json",
                                             "nojsoncallback": 1,
                                             "text": searchString,
                                             "extras": "url_m",
                                             "per_page": 5]
        
        Alamofire.request(requestURL, parameters: searchParameters, headers: nil).responseJSON { (response) in
            
            if let allResponse = response.result.value as? [String : AnyObject] {
                let photos = allResponse["photos"]!
                let photoArray = photos["photo"] as? [[String : AnyObject]]
                let imageWidth = self.view.frame.width
                self.scrollView.contentSize = CGSize(width: imageWidth, height: imageWidth * CGFloat((photoArray?.count)!))
                
                for (i,photoDictionary) in (photoArray?.enumerated())! {                             //1
                    if let imageURLString = photoDictionary["url_m"] as? String {               //2
                        let imageData = NSData(contentsOf: URL(string: imageURLString)!)        //2
                        if let imageDataUnwrapped = imageData {                                     //3
                            let imageView = UIImageView(image: UIImage(data: imageDataUnwrapped as Data))   //4
                            imageView.frame = CGRect(x: 0, y: 320 * CGFloat(i), width: imageWidth, height: imageWidth) //5
                            self.scrollView.addSubview(imageView)                                   //6
                        }
                    }
                }
            }
            
            
        }
        
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
    
        for subview in self.scrollView.subviews {
            subview.removeFromSuperview()
        }
        searchBar.resignFirstResponder()
        searchFlickrBy(searchString: searchBar.text!)
    }
    

}

