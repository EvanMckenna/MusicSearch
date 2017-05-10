//
//  ViewController.swift
//  MusicSearch
//
//  Created by Evan  on 10/05/2017.
//  Copyright © 2017 Evan . All rights reserved.
//

import UIKit
import Alamofire



struct song {
    let finalImage : UIImage
    let name : String!
}
class TableViewController: UITableViewController {

    var songs = [song]()
    var searchURL = "https://api.spotify.com/v1/search?q=Foo+Fighters&type=track&limit=10&offset=5"
    typealias JSONExp = [String : AnyObject]
    override func viewDidLoad() {
        
        
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
   callAlamo(url: searchURL)
        
        for parent in navigationController!.view.subviews {
            for child in parent.subviews {
                for view in child.subviews {
                    if view is UIImageView && view.frame.height == 0.5 {
                        view.alpha = 0
                    }
                }
            }
        }

        
    }
    
    
    
    
    //call url
    func callAlamo(url : String){
        
        Alamofire.request(url).responseJSON(completionHandler: {
            
            response in
            
            self.parseData(JSONData: response.data!)
            
        })
        
        
        
    }
    
    func parseData(JSONData : Data) {
        
        do {
            
            var readableJSON = try JSONSerialization.jsonObject(with: JSONData, options: .mutableContainers) as! JSONExp
            if let tracks = readableJSON["tracks"] as? JSONExp{
            if let items = tracks["items"] as? [JSONExp] {
                    for i in 0..<items.count{
                        let item = items[i] as! JSONExp
                        print(item)
                        let name = item["name"] as! String
                        
                        
                        if let album = item["album"] as? JSONExp{
                            if let images = album["images"] as? [JSONExp]{
                                let imagecover = images[0]
                                let imageURL =  URL(string : imagecover ["url"] as! String)
                                let imagecoverdata = NSData(contentsOf: imageURL!)
                           
                                let finalImage = UIImage(data: imagecoverdata as! Data)
                            
                                songs.append(song.init(finalImage: finalImage!, name: name))
                                self.tableView.reloadData()

                                
                            }
                            
                        }
                        
                        
                        
        
                        
                        
                    }
                }
            }
        }
        
        catch {
            print(error)
        }
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return songs.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell")
        
       let imageView = cell?.viewWithTag(2) as! UIImageView
        
        imageView.image = songs[indexPath.row].finalImage
        
        let nameLabel = cell?.viewWithTag(1) as! UILabel
        
        nameLabel.text = songs[indexPath.row].name
        
        self.view.layoutIfNeeded()
        imageView.layer.cornerRadius = imageView.frame.size.width/2
        imageView.clipsToBounds = true
        
        return cell!
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

