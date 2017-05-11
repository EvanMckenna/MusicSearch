//
//  Player.swift
//  MusicSearch
//
//  Created by Evan  on 11/05/2017.
//  Copyright © 2017 Evan . All rights reserved.
//

import UIKit
import AVFoundation

class Player: UIViewController {
    
    @IBOutlet weak var popUpView: UIView!
    @IBOutlet weak var albumCover: UIImageView!
    @IBOutlet weak var song: UILabel!
    @IBOutlet weak var playButton: UIButton!
    
    var image = UIImage()
    var songTitle = String()
    var previewSongPop = String()
    
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        popUpView.layer.cornerRadius = 10
        popUpView.layer.masksToBounds = true
        
        song.text = songTitle
        albumCover.image = image
        
        
        downloadURL(url: URL(string: previewSongPop)!)


        // Do any additional setup after loading the view.
    }

    
    func downloadURL(url: URL){
        var downloadTask = URLSessionDownloadTask()
        downloadTask = URLSession.shared.downloadTask(with: url, completionHandler: {
            
            songURL,response, error in
            
            self.play(url: songURL!)
            
        })
        
        downloadTask.resume()
    }
    

    func play(url: URL){
        
        do {
            player = try AVAudioPlayer(contentsOf: url)
            player.prepareToPlay()
            player.play()
            
        }
        catch{
            print(error)
            
        }
    }
    
    @IBAction func PlaySong(_ sender: Any) {
        if player.isPlaying {
            player.pause()
            playButton.setImage(UIImage(named: "Asset 9.png"), for: UIControlState.normal)
       
        }
        else{
            player.play()
            playButton.setImage(UIImage(named: "Asset 10.png"), for: UIControlState.normal)
            
        }
    }

    @IBAction func closePopUp(_ sender: Any) {
        dismiss(animated: true, completion: nil)
        player.pause()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
