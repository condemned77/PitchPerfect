//
//  RecordSoundViewController.swift
//  Pitch Perfect
//
//  Created by jason on 15/03/15.
//
//

import UIKit
import AVFoundation



class RecordSoundViewController: UIViewController, AVAudioRecorderDelegate {

  @IBOutlet weak var recording_label: UILabel!
  @IBOutlet weak var stop_button: UIButton!
  @IBOutlet weak var recording_button: UIButton!
  
  //Declared Globally
  var audioRecorder:AVAudioRecorder!
  
  
  override func viewDidLoad() {
      super.viewDidLoad()
      // Do any additional setup after loading the view, typically from a nib.
      self.stop_button.hidden = true
  }
  
  override func viewWillAppear(animated: Bool) {
      self.recording_button.enabled = true
  }

  override func didReceiveMemoryWarning() {
      super.didReceiveMemoryWarning()
      // Dispose of any resources that can be recreated.
  }
  
  func audioRecorderDidFinishRecording(recorder: AVAudioRecorder!, successfully flag: Bool) {
    if flag {
        //do something
        println("recording successfully finished")

        /*concerning the review, I do call the initializer here, don't I?
        It looks like I don't understand the review.*/
        let recorded_audio = RecordedAudio(title:recorder.url.lastPathComponent, filePathURL:recorder.url)
        self.performSegueWithIdentifier("stopRecordingSegue", sender: recorded_audio)
    }
    else{
      println("recording successfully finished")
    }
  }
  
  override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
    if segue.identifier == "stopRecordingSegue" {
      let playSoundsVC = segue.destinationViewController as PlaySoundViewController
      playSoundsVC.recorded_audio = sender as RecordedAudio
    }
  }
  
  func configure_UIButtons_when_start_recording_button_is_pressed(){
    self.recording_label.hidden   = !self.recording_label.hidden
    self.stop_button.hidden       = false
    self.recording_button.enabled = false
  }

  func create_recording_file_name()-> String{
    
    let currentDateTime = NSDate()
    let formatter = NSDateFormatter()
    formatter.dateFormat = "ddMMyyyy-HHmmss"
    return formatter.stringFromDate(currentDateTime)+".wav"
  }
  
  func default_file_path_for_audio_recording()->NSURL{

    let dirPath = NSSearchPathForDirectoriesInDomains(.DocumentDirectory, .UserDomainMask, true)[0] as String
    let recording_file_name = create_recording_file_name()
    let pathArray = [dirPath, recording_file_name]

    return NSURL.fileURLWithPathComponents(pathArray)!
  }
  
  func configure_AVAudioRecorder_session() {
    var session = AVAudioSession.sharedInstance()
    session.setCategory(AVAudioSessionCategoryPlayAndRecord, error: nil)
  }
  
  func start_recording() {
    
    let filePath = default_file_path_for_audio_recording()
    println(filePath)
    
    self.configure_AVAudioRecorder_session()
    audioRecorder = self.create_audio_recorder_and_initialise(filePath: filePath)
    audioRecorder.record()
  }
  
  
  func create_audio_recorder_and_initialise(filePath file_path:NSURL) -> AVAudioRecorder{
    let audioRecorder = AVAudioRecorder(URL: file_path, settings: nil, error: nil)
    audioRecorder.meteringEnabled = true
    audioRecorder.prepareToRecord()
    audioRecorder.delegate = self
    return audioRecorder
  }
  
  func configure_UIButtons_when_stop_recording_button_is_pressed(){
    self.recording_label.hidden = true
    self.recording_button.enabled = true
    self.stop_button.hidden = true
  }
  
  func stop_recording() {
    audioRecorder.stop()
    var audioSession = AVAudioSession.sharedInstance()
    audioSession.setActive(false, error: nil)
  }

  @IBAction func start_recording_pressed(sender: UIButton) {
    self.configure_UIButtons_when_start_recording_button_is_pressed()
    self.start_recording()
  }

  @IBAction func stop_button_pressed(sender: UIButton) {
    self.configure_UIButtons_when_stop_recording_button_is_pressed()
    self.stop_recording()
  }
}

