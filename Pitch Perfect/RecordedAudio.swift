//
//  RecordedAudio.swift
//  Pitch Perfect
//
//  Created by jason on 03/04/15.
//
//

import Foundation
import AVFoundation


class RecordedAudio: NSObject {
  
    var title: String!
    var filePathURL: NSURL!
    
    
    init (title:String!, filePathURL: NSURL!) {
        self.title = title
        self.filePathURL = filePathURL
        println("constructor called")
    }
    
    func createAVAudioFile() -> AVAudioFile{
        return AVAudioFile(forReading: self.filePathURL, error: nil)
    }
    
}