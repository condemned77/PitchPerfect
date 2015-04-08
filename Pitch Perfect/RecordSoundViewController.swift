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
        self.recording_button.enabled   = true
        self.recording_label.text       = "Tap to Record"
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    func audioRecorderDidFinishRecording(recorder: AVAudioRecorder!,
                                successfully flag: Bool) {
        if flag {
            //do something
            println("recording successfully finished")

            /*concerning the review, I do call the initializer here, don't I?
            It looks like I don't understand the review.*/
            let recorded_audio = RecordedAudio(title:recorder.url.lastPathComponent, filePathURL:recorder.url)

            self.performSegueWithIdentifier("stopRecordingSegue", sender: recorded_audio)
        }
        else{
            println("recording error")
        }
    }

    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "stopRecordingSegue" {
            let playSoundsVC            = segue.destinationViewController as PlaySoundViewController
            playSoundsVC.recorded_audio = sender as RecordedAudio
        }
    }

    func configure_UIButtons_when_start_recording_button_is_pressed(){
        self.stop_button.hidden       = false
        self.recording_button.enabled = false
    }

    func create_file_name_of_recording()-> String{

        let currentDateTime = NSDate()
        let formatter = NSDateFormatter()
        formatter.dateFormat = "ddMMyyyy-HHmmss"
        return formatter.stringFromDate(currentDateTime)+".wav"
    }

    /*This method creates (and returns) a default file path which looks like this:
    .../Documents/08042015-081957.wav. The file is stored in the documents
    folder of the current user's iPhone. 
    The default file name comprises of the current date and time. See
    method create_file_name_of_recording for details.
    */
    func default_file_path_for_audio_recording()->NSURL{
        let dirPath = NSSearchPathForDirectoriesInDomains(.DocumentDirectory, .UserDomainMask, true)[0] as String
        let recording_file_name = self.create_file_name_of_recording()
        let pathArray = [dirPath, recording_file_name]

        return NSURL.fileURLWithPathComponents(pathArray)!
    }


    func configure_AVAudioRecorder_session() {
        var session = AVAudioSession.sharedInstance()
        session.setCategory(AVAudioSessionCategoryPlayAndRecord, error: nil)
    }

    /*Convenience method for recording an audio at a default file path.
    Here, all the setup for an AVAudioRecorder instance and AVAudiosession is done.
    */
    func start_recording() {
        let filePath = default_file_path_for_audio_recording()
        println(filePath)

        self.configure_AVAudioRecorder_session()
        audioRecorder = self.create_audio_recorder_and_initialise(filePath: filePath)
        audioRecorder.record()
    }

    /*This method is used to instanciate (create) an AVAudioRecorder instance and
    initialises it with the file path where the file will be stored.*/
    func create_audio_recorder_and_initialise(filePath file_path:NSURL) -> AVAudioRecorder{
        let audioRecorder = AVAudioRecorder(URL: file_path, settings: nil, error: nil)
        audioRecorder.meteringEnabled = true
        audioRecorder.prepareToRecord()
        audioRecorder.delegate = self
        return audioRecorder
    }

    func configure_UIButtons_when_stop_recording_button_is_pressed(){
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
        self.recording_label.text = "recording"
        self.start_recording()
    }

    @IBAction func stop_button_pressed(sender: UIButton) {
        self.recording_label.text = "Tap to Record"
        self.configure_UIButtons_when_stop_recording_button_is_pressed()
        self.stop_recording()
    }
}