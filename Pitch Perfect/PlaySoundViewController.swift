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
   
  @IBOutlet weak var stop_button: UIButton!
    
    func read_movie_quote_file_path() -> String!{
      let file_path = NSBundle.mainBundle().pathForResource("movie_quote", ofType: "mp3")
      println(file_path)
      return file_path
    }
    
    
    override func viewDidLoad() {
      super.viewDidLoad()

      // Do any additional setup after loading the view.
      self.read_movie_quote_file_path()
      self.stop_button.hidden = true
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
    self.play_movie_quote_slow()
    self.stop_button.hidden = false
  }
    
  @IBAction func fast_button_pressed(sender: UIButton) {
      self.play_movie_quote_fast()
      self.stop_button.hidden = false
  }
  
  @IBAction func stop_button_pressed(sender: UIButton) {
    self.audio_player?.stop()
  }
  
  
  func play_movie_quote_fast() {
    let file_path = self.read_movie_quote_file_path()
    self.audio_player = self.init_audio_player_with_path(file_path)
    self.play_sound_with_rate(2.0)
  }
    
  func play_movie_quote_slow() {
    let file_path = self.read_movie_quote_file_path()
    self.audio_player = self.init_audio_player_with_path(file_path)
    self.play_sound_with_rate(0.5)
  }
  
  func play_sound_with_rate(rate:Float) {
    self.set_playback_rate(rate)
    self.audio_player?.stop()
    self.audio_player?.play()
  }
  
  func set_playback_rate(rate:Float) {
    assert(rate >= 0.5, "rate must be between 0.5 and 2.0")
    assert(rate <= 2.0, "rate must be between 0.5 and 2.0")
    self.audio_player?.enableRate = true
    self.audio_player?.rate=rate
  }
  
  func init_audio_player_with_path(path: String!) -> AVAudioPlayer?{
    let movie_quote_url = NSURL(fileURLWithPath: path)
    var error: NSError?
    return AVAudioPlayer(contentsOfURL: movie_quote_url, fileTypeHint: "mp3", error: &error)
  }
}
