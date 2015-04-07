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

    /*I don't understand the review here.
    This method should be the initializer, as I've found
    in the swift book p22:
    “var name: String
    init(name: String) {
    self.name = name
    }”
    “Notice how self is used to distinguish the name property from the name argument to the initializer. The arguments to the initializer are passed like a function call when you create an instance of the class. Every property needs a value assigned—either in its declaration (as with numberOfSides) or in the initializer (as with name).”
    Excerpt From: Apple Inc. “The Swift Programming Language.” iBooks. https://itun.es/de/jEUH0.l
    
    
    I choose this initializer version because, from my point of view,
    an instance of this model should not exist without these properties.
    Therefore, I want to "force" a user of this class to pass the relevant
    arguments directly.
    */
    init (title:String!, filePathURL: NSURL!) {
        self.title = title
        self.filePathURL = filePathURL
        println("constructor called")
    }

    /*convenience method for creaing an AVAudioFile instance directly from
    an instance of RecordedAudio*/
    func createAVAudioFile() -> AVAudioFile{
        return AVAudioFile(forReading: self.filePathURL, error: nil)
    }
}