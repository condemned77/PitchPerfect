//
//  ViewController.swift
//  Pitch Perfect
//
//  Created by jason on 15/03/15.
//
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var recording_label: UILabel!
    @IBOutlet weak var stop_button: UIButton!

    @IBOutlet weak var recording_button: UIButton!
    
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
    
    func start_recording() {
        self.recording_label.hidden = !self.recording_label.hidden
        
        self.stop_button.hidden = false
        self.recording_button.enabled = false
    }
    
    func stop_recording() {
        self.recording_label.hidden = true
        self.recording_button.enabled = true
        self.stop_button.hidden = true
    }

    @IBAction func start_recording_pressed(sender: UIButton) {
        
        self.start_recording()
    }

    @IBAction func stop_button_pressed(sender: UIButton) {

        self.stop_recording()
    }
}

