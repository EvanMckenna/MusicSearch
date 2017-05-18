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

        
        //Api which searches. This is replaced with the keyword. This is necessary to allow users to search for any artist as the this key needs to update everytime.
        searchURL = "https://api.spotify.com/v1/search?q=\(artistKeywords!)&type=track&offset=25"
        print(searchURL)
        
        // Call the function, this puts the searchURL as the String in the function
        callAlamo(url: searchURL)
        
        //Ends the keyboard
        self.view.endEditing(true)
        
        
        Search()
        
        
    }
    override func viewDidLoad() {
        
        
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
   callAlamo(url: searchURL)
        self.navigationItem.setHidesBackButton(true, animated: false)
        //Removes the line under the navigation bar
        for parent in navigationController!.view.subviews {
            for child in parent.subviews {
                for view in child.subviews {
                    if view is UIImageView && view.frame.height == 0.5 {
                        view.alpha = 0
                    }
                }
            }
        }

        
        let textfieldAppearence = UITextField.appearance()
        textfieldAppearence.keyboardAppearance = .dark
        
        
    }
    
    //Updates the table. After each search deletes the array and repopulates with new artist
    func Search() {
        songs.removeAll()
    }
    
    //call url.. This allows Alamo to get the data in the above url
    func callAlamo(url : String){
        
        
        Alamofire.request(url).responseJSON(completionHandler: {
            
            response in
            
            self.parseData(JSONData: response.data!)
            
        })
        
        
        
    }
    
    //Makes the data readable i.e Parsing the JSON
    func parseData(JSONData : Data) {
        
        do {
            
            var readableJSON = try JSONSerialization.jsonObject(with: JSONData, options: .mutableContainers) as! JSONExp
            //Accessing Tracks
            if let tracks = readableJSON["tracks"] as? JSONExp{
                
                //Accessing items
            if let items = tracks["items"] as? [JSONExp] {
                
                
                //Cycle and count the items from items
                    for i in 0..<items.count{
                        
                        //Selection the items
                        let item = items[i]
                        print(item)
                        
                        //Getting the name
                        let name = item["name"] as! String
                        
                        //Getting the preview as a String
                        let previewSong = item["preview_url"] as! String
                        
                        
                        //Getting the art
                        if let album = item["album"] as? JSONExp{
                            if let images = album["images"] as? [JSONExp]{
                                let imagecover = images[0]
                                
                                //URL is the url of the image in the image cover array as a string ^^
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
        //print error if nothing is there
        catch {
            print(error)
        }
    }
    
    //Need this for the table view
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return songs.count
    }
    
    //Need this for the table view
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell")
        
        //setting the image view tagged as 2 in the identifier
       let imageView = cell?.viewWithTag(2) as! UIImageView
        
        //Setting this image to the finalImage (Cover) to that imageview
        imageView.image = songs[indexPath.row].finalImage
        
        //same with the label
        let nameLabel = cell?.viewWithTag(1) as! UILabel
        
        nameLabel.text = songs[indexPath.row].name
        
        //To create the border of the image view behind the cover
        self.view.layoutIfNeeded()
        //Rounded corners
        imageView.layer.cornerRadius = imageView.frame.size.width/2
        imageView.clipsToBounds = true
        
        return cell!
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let indexPath = self.tableView.indexPathForSelectedRow?.row
        
        let view = segue.destination as! Player
        
        //Passing values to other view controller (Player)
        view.image = songs[indexPath!].finalImage
        view.songTitle = songs[indexPath!].name
        view.previewSongPop  = songs[indexPath!].previewSong
        
        
    }
    
  
    



 
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

