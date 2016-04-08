//
//  ViewController.swift
//  Audio-Player
//
//  Created by mitchell hudson on 4/8/16.
//  Copyright © 2016 mitchell hudson. All rights reserved.
//


// Simple Audio Player with notes

import UIKit
import AVFoundation // Import the AVFoundation

class ViewController: UIViewController {

    // Formatting time for display
    let timeFormatter = NSNumberFormatter()
    
    var audioPlayer: AVAudioPlayer? // holds an audio player instance. This is an optional!
    var audioTimer: NSTimer?        // holds a timer instance
    var isPlaying = false {         // keep track of when the player is playing
        didSet {                    // This is a computed property. Changing the value
            setButtonState()        // invokes the didSet block
            playPauseAudio()
        }
    }
    
    
    
    // MARK: IBOutlets
    
    @IBOutlet var playButton: UIButton!
    @IBOutlet var progressBar: UIProgressView!
    @IBOutlet var timeSlider: UISlider!
    @IBOutlet var volumeSlider: UISlider!
    @IBOutlet var timeLabel: UILabel!
    
    
    // MARK: IBActions
    
    @IBAction func playButtonTapped(sender: UIButton) {
        // Set the didSet block above! Setting this value will play and pause the audio
        
        isPlaying = !isPlaying
    }
    
    @IBAction func timeSliderChanged(sender: UISlider) {
        // Working on this 
        // TODO: Implement Time Slider
        guard let audioPlayer = audioPlayer else {
            return
        }
        
        audioPlayer.currentTime = audioPlayer.duration * Double(sender.value)
    }
    
    @IBAction func volumeSliderChanged(sender: UISlider) {
        // Use a guard statement here since audioPlayer is optional
        guard let audioPlayer = audioPlayer else {
            return
        }
        // If audioPlayer is not nil set the volume
        audioPlayer.volume = sender.value
    }
    
    
    
    
    func setButtonState() {
        // When the play button is tapped the text changes
        // TODO: Use the enum below for button and player states
        if isPlaying {
            playButton.setTitle("Pause", forState: .Normal)
        } else {
            playButton.setTitle("Play", forState: .Normal)
        }
    }
    
    func playPauseAudio() {
        // audioPlayer is optional use guard to check it before using it.
        guard let audioPlayer = audioPlayer else {
            return
        }
        
        // Check is playing then play or pause
        if isPlaying {
            audioPlayer.play()
        } else {
            audioPlayer.pause()
        }
    }
    
    
    
    func queueSound() {
        // Use this methid to load up the sound.
        let contentURL = NSURL(fileURLWithPath: NSBundle.mainBundle().pathForResource("sweet", ofType: "mp3")!)
        // TODO: Use catch here and check for errors.
        audioPlayer = try! AVAudioPlayer(contentsOfURL: contentURL)
    }
    
    
    func makeTimer() {
        // This function sets up the timer.
        if audioTimer != nil {
            audioTimer!.invalidate()
        }
        
        audioTimer = NSTimer.scheduledTimerWithTimeInterval(1, target: self, selector: #selector(ViewController.onTimer(_:)), userInfo: nil, repeats: true)
    }
    
    func onTimer(timer: NSTimer) {
        // Check the audioPlayer, it's optinal remember. Get the current time and duration
        guard let currentTime = audioPlayer?.currentTime, let duration = audioPlayer?.duration else {
            return
        }
        
        // Calculate minutes, seconds, and percent completed
        let mins = currentTime / 60
        let secs = currentTime % 60
        let percentCompleted = currentTime / duration
        
        // Use the number formatter, it might return nil so guard
        guard let minsStr = timeFormatter.stringFromNumber(mins), let secsStr = timeFormatter.stringFromNumber(secs) else {
            return
        }
        
        // Everything is cool so update the timeLabel and progress bar
        timeLabel.text = "\(minsStr):\(secsStr)"
        progressBar.progress = Float(percentCompleted)
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Setup a number formatter that rounds down and pads with a 0
        timeFormatter.minimumIntegerDigits = 2
        timeFormatter.minimumFractionDigits = 0
        timeFormatter.roundingMode = .RoundDown
        
        // Load the sound and set up the timer.
        queueSound()
        makeTimer()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}



// TODO: Use Enum to manage play state
enum PlayState: String {
    case Play = "Play"
    case Puase = "Pause"
}

