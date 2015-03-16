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
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func start_recording(sender: UIButton) {
        
        self.recording_label.hidden = !self.recording_label.hidden
    }

}

