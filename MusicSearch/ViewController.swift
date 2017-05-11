//
//  ViewController.swift
//  MusicSearch
//
//  Created by Evan  on 10/05/2017.
//  Copyright © 2017 Evan . All rights reserved.
//

import UIKit
import Alamofire
import AVFoundation

var player = AVAudioPlayer()

struct song {
    let finalImage : UIImage
    let previewSong : String!
    let name : String!
}
class TableViewController: UITableViewController, UISearchBarDelegate {

    
    @IBOutlet weak var SearchBar: UISearchBar!

    
    var songs = [song]()
    var searchURL = String()
    var previewSong = String()
    
    typealias JSONExp = [String : AnyObject]
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        let keywords = SearchBar.text
        
       let artistKeywords = keywords?.replacingOccurrences(of: " ", with: "+")
        
        searchURL = "https://api.spotify.com/v1/search?q=\(artistKeywords!)&type=track&offset=25"
        print(searchURL)
        callAlamo(url: searchURL)
        self.view.endEditing(true)
        Search()
        
        
    }
    override func viewDidLoad() {
        
        
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
   callAlamo(url: searchURL)
        self.navigationItem.setHidesBackButton(true, animated: false)
        
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
    
    
    func Search() {
        songs.removeAll()
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
                        let previewSong = item["preview_url"] as! String
                        
                        if let album = item["album"] as? JSONExp{
                            if let images = album["images"] as? [JSONExp]{
                                let imagecover = images[0]
                                let imageURL =  URL(string : imagecover ["url"] as! String)
                                let imagecoverdata = NSData(contentsOf: imageURL!)
                           
                                let finalImage = UIImage(data: imagecoverdata as! Data)
                            
                                songs.append(song.init(finalImage: finalImage!, previewSong: previewSong, name: name))
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
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let indexPath = self.tableView.indexPathForSelectedRow?.row
        
        let view = segue.destination as! Player
        
        view.image = songs[indexPath!].finalImage
        view.songTitle = songs[indexPath!].name
        view.previewSongPop  = songs[indexPath!].previewSong
    }
    
  
    



 
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

