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
    var recorded_audio: RecordedAudio!
    var audio_engine: AVAudioEngine! = nil
  
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
        self.audio_engine = AVAudioEngine()
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
    //    self.play_movie_quote_slow()
        self.play_recorded_audio_slow()
        self.stop_button.hidden = false
    }

    @IBAction func fast_button_pressed(sender: UIButton) {
    //      self.play_movie_quote_fast()
        self.play_recorded_audio_fast()
        self.stop_button.hidden = false
    }

    @IBAction func stop_button_pressed(sender: UIButton) {
//        self.audio_player?.stop()
        self.reset_audio_engine_and_player()
    }
    
    func reset_audio_engine_and_player() {
        self.audio_player?.stop()
        self.audio_engine.stop()
        self.audio_engine.reset()
    }
  
    @IBAction func chipmunk_button_pressed(sender: UIButton) {
        self.reset_audio_engine_and_player()
        self.play_recorded_audio_with_pitch(1000.0)
        self.stop_button.hidden = false
    }
    
    @IBAction func darth_vader_button_pressed(sender: AnyObject) {
        self.reset_audio_engine_and_player()
        self.play_recorded_audio_with_pitch(-1000.0)
        self.stop_button.hidden = false
    }
    
  
    func play_recorded_audio_with_pitch(pitch: Float) {
        var pitchPlayer = AVAudioPlayerNode()
        var timePitch = AVAudioUnitTimePitch()
        timePitch.pitch = pitch
        
        self.audio_engine.attachNode(pitchPlayer)
        self.audio_engine.attachNode(timePitch)
        
        self.audio_engine.connect(pitchPlayer, to: timePitch, format: nil)
        self.audio_engine.connect(timePitch, to: self.audio_engine.outputNode, format: nil)
        
        pitchPlayer.scheduleFile(self.recorded_audio.createAVAudioFile(), atTime: nil, completionHandler: nil)
        
        var error:NSError? = NSError()
        self.audio_engine.startAndReturnError(&error)
        
        pitchPlayer.play()

    }
    
    func play_movie_quote_fast() {
        let file_path = self.read_movie_quote_file_path()
        self.audio_player = self.init_audio_player_with_path(file_path)
        self.play_sound_with_rate(2.0)
    }
  
    func play_recorded_audio_fast(){
        self.audio_player = self.init_audio_player_with_recorded_audio_wav(self.recorded_audio)
        self.play_sound_with_rate(2.0)
    }
    
    
    func play_movie_quote_slow() {
        let file_path = self.read_movie_quote_file_path()
        self.audio_player = self.init_audio_player_with_path(file_path)
        self.play_sound_with_rate(0.5)
    }
  
    func play_recorded_audio_slow() {
        self.audio_player = self.init_audio_player_with_recorded_audio_wav(self.recorded_audio)
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
        self.audio_player?.rate = rate
    }
  
    func init_audio_player_with_path(path: String!) -> AVAudioPlayer?{
        let movie_quote_url = NSURL(fileURLWithPath: path)
        var error: NSError?
        return AVAudioPlayer(contentsOfURL: movie_quote_url, fileTypeHint: "mp3", error: &error)
    }
  
    func init_audio_player_with_recorded_audio_wav(recorded_audio: RecordedAudio!) -> AVAudioPlayer?{
        var error: NSError?
        return    AVAudioPlayer(contentsOfURL: recorded_audio.filePathURL, fileTypeHint: "wav", error: &error)
    }

}
