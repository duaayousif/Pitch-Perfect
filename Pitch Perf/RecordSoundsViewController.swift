//
//  RecordSoundsViewController.swift
//  Pitch Perf
//
//  Created by Duaa Abdelgadir on 2015-05-23.
//  Copyright (c) 2015 Duaa Abdelgadir. All rights reserved.
//

import UIKit
import AVFoundation



class RecordSoundsViewController: UIViewController, AVAudioRecorderDelegate {
    @IBOutlet weak var recordButton: UIButton!
    @IBOutlet weak var recordingInProgress: UILabel!
    @IBOutlet weak var stopButton: UIButton!
    var audioRecorder: AVAudioRecorder!
    var recordedAudio: RecordedAudio!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func recordAudio(sender: UIButton) {
        stopButton.hidden = false
        recordingInProgress.hidden = false
        recordButton.enabled = false
        //TODO: Record users voice
        let dirPath = NSSearchPathForDirectoriesInDomains(.DocumentDirectory, .UserDomainMask, true)[0] as! String
        /*
        var currentDateTime = NSDate()
        var formatter = NSDateFormatter()
        formatter.dateFormat = "ddMMyyyy-HHmmss"*/
        var recordingName = "my_audio.wav"
        var pathArray = [dirPath, recordingName]
        let filePath = NSURL.fileURLWithPathComponents(pathArray)
        print(filePath);
         var session = AVAudioSession.sharedInstance()
        session.setCategory(AVAudioSessionCategoryPlayAndRecord, error: nil)
        // Initialize & prepare recorder
        audioRecorder = AVAudioRecorder(URL: filePath!, settings: nil, error: nil)
        audioRecorder.delegate = self
        audioRecorder.meteringEnabled = true;
        audioRecorder.prepareToRecord()
        audioRecorder.record()
        
        //println("in recordAudio")
    }
    func audioRecorderDidFinishRecording(recorder: AVAudioRecorder!, successfully flag: Bool) {
        
        if (flag) {
            recordedAudio = RecordedAudio()
            recordedAudio.filePathUrl = recorder.url
            // name of recorded file
            recordedAudio.title = recorder.url.lastPathComponent
            self.performSegueWithIdentifier("stopRecording", sender: recordedAudio)
        }
        else {
            println("recording was not successful")
            recordButton.enabled = true
            stopButton.hidden = true
        }
    }
    
    // gets called right before a segway is performed
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if (segue.identifier == "stopRecording") {
            let playSoundsVC:PlaySoundsViewController = segue.destinationViewController as! PlaySoundsViewController
                let data = sender as! RecordedAudio
                playSoundsVC.recievedAudio = data
        }
    }
    @IBAction func stopAudio(sender: UIButton) {
        recordingInProgress.hidden = true;
        audioRecorder.stop()
        var audioSession = AVAudioSession.sharedInstance()
        audioSession.setActive(false, error: nil)
    }
    override func viewWillAppear(animated: Bool) {
        stopButton.hidden = true
        recordButton.enabled = true
    }
}

