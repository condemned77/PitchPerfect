//
//  PlaySoundViewController.swift
//  Pitch Perfect
//
//  Created by jason on 22/03/15.
//
//
import Foundation
import UIKit
import AVFoundation

class PlaySoundViewController: UIViewController {

    var audio_player: AVAudioPlayer? = nil
   
    
    func read_movie_quote_file_path() -> String!{
        let manager = NSFileManager.defaultManager()
        
      let file_path = NSBundle.mainBundle().pathForResource("movie_quote", ofType: "mp3")
        println(file_path)
        return file_path
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.read_movie_quote_file_path()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

    @IBAction func slow_button_pressed(sender: UIButton) {
        self.play_movie_quote()
        
    }
    
    
    func play_movie_quote() {
      self.audio_player = self.init_audio_player_with_path(self.read_movie_quote_file_path())

      self.audio_player?.play()
    }
  
  
  func init_audio_player_with_path(path: String!) -> AVAudioPlayer?{
    let movie_quote_url = NSURL(fileURLWithPath: path)
    var error: NSError?
    return AVAudioPlayer(contentsOfURL: movie_quote_url, fileTypeHint: "mp3", error: &error)
  }
}
