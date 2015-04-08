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

    /*When the view is loaded, the stop button is set to hidden, since it's useless
    unless audio is being played. Also an AVAudioEngine instance is created since it's
    being used throughout this class.*/
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.stop_button.hidden = true
        self.audio_engine = AVAudioEngine()
    }

    /*When the slow button is pressed the following happens:
    - the audio engine and player is being resetted, because this ensures that
    currently playing audio (in case it happens) is being stopped before playing
    new audio.
    
    - the current audio file is played slowly.
    
    - the stop button is made visible in order to be able to stop playing audio.*/
    @IBAction func slow_button_pressed(sender: UIButton) {
        self.reset_audio_engine_and_player()
        self.play_recorded_audio_slow()
        self.stop_button.hidden = false
    }


    /*When the fast button is pressed the following happens:
    - the audio engine and player is being resetted, because this ensures that
    currently playing audio (in case it happens) is being stopped before playing
    new audio.

    - the current audio file is played fast.

    - the stop button is made visible in order to be able to stop playing audio.*/
    @IBAction func fast_button_pressed(sender: UIButton) {
        self.reset_audio_engine_and_player()
        self.play_recorded_audio_fast()
        self.stop_button.hidden = false
    }

    /*When the stop button is pressed, the audio player and audio engine is
    being resetted. This ensures that the audio replay is being stopped.*/
    @IBAction func stop_button_pressed(sender: UIButton) {
        self.reset_audio_engine_and_player()
    }

    /*This method resets the audio engine and the audio player.
    It just calls the necessary method on the relevant objects.*/
    func reset_audio_engine_and_player() {
        self.audio_player?.stop()
        self.audio_engine.stop()
        self.audio_engine.reset()
    }

    
    /*When the chipmunk button is pressed the following happens:
    - the audio engine and player is being resetted, because this ensures that
    currently playing audio (in case it happens) is being stopped before playing
    new audio.

    - the current audio file is played with a pitch of 1000. Through this, the audio played
    sounds like a chipmunk.

    - the stop button is made visible in order to be able to stop playing audio.*/
    @IBAction func chipmunk_button_pressed(sender: UIButton) {
        self.reset_audio_engine_and_player()
        self.play_recorded_audio_with_pitch(1000.0)
        self.stop_button.hidden = false
    }


    /*When the darth vader button is pressed the following happens:
    - the audio engine and player is being resetted, because this ensures that
    currently playing audio (in case it happens) is being stopped before playing
    new audio.

    - the current audio file is played with a pitch of -1000. Through this, the audio played
    sounds like darth vader.

    - the stop button is made visible in order to be able to stop playing audio.*/
    @IBAction func darth_vader_button_pressed(sender: AnyObject) {
        self.reset_audio_engine_and_player()
        self.play_recorded_audio_with_pitch(-1000.0)
        self.stop_button.hidden = false
    }
    

    /*This method allows for playing the currently available audio file (through the iVar recorded_audio)
    with a pitch passed in via a method parameter (pitch).
    In order to achive this, the method uses instances of the class AVAudioUnitTimePitch and AVAudioPlayerNode.
    During the method workflow AVAudioNode instances (rather subclasses of this class) are connected within the
    AVAudioEngine. Then, the audio engine is connected to an output. In case of this app, it's the iphone's 
    speaker.
    Lastly the audio file is played.*/
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

    /*The method allows for playing the recently recorded audio file at 2x speed.*/
    func play_recorded_audio_fast(){
        self.audio_player = self.init_audio_player_with_recorded_audio_wav(self.recorded_audio)
        self.play_sound_with_rate(2.0)
    }
    
    /*The method allows for playing the recently recorded audio file at 0.5x speed.*/
    func play_recorded_audio_slow() {
        self.audio_player = self.init_audio_player_with_recorded_audio_wav(self.recorded_audio)
        self.play_sound_with_rate(0.5)
    }

    /*This method allows for playing the recently recorded audio file while passing in a playback rate.*/
    func play_sound_with_rate(rate:Float) {
        self.set_playback_rate(rate)
        self.audio_player?.stop()
        self.audio_player?.play()
    }

    /*This method applies the playback rate to the audio player. The playback rate has to be
    between 0.5 and 2.0.*/
    func set_playback_rate(rate:Float) {
        assert(rate >= 0.5, "rate must be between 0.5 and 2.0")
        assert(rate <= 2.0, "rate must be between 0.5 and 2.0")
        self.audio_player?.enableRate = true
        self.audio_player?.rate = rate
    }
  

    /*This method creates an AVAudioPlayer instance using the model instance of RecordedAudio.*/
    func init_audio_player_with_recorded_audio_wav(recorded_audio: RecordedAudio!) -> AVAudioPlayer?{
        var error: NSError?
        return    AVAudioPlayer(contentsOfURL: recorded_audio.filePathURL, fileTypeHint: "wav", error: &error)
    }

}
