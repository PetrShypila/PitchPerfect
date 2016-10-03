//
//  RecordSoundsViewController.swift
//  PitchPerfect
//
//  Created by Petr Shypila on 30/09/2016.
//  Copyright © 2016 Petr Shypila. All rights reserved.
//

import UIKit
import AVFoundation

class RecordSoundsViewController: UIViewController, AVAudioRecorderDelegate{

    @IBOutlet weak var recordingLabel: UILabel!
    @IBOutlet weak var recordButton: UIButton!
    @IBOutlet weak var stopRecordButton: UIButton!
    
    var audioRecorder:AVAudioRecorder!
    let recordInProgress = "Recording in progress"
    let tapToRecord = "Tap to Record"
    
    @IBAction func recordAudio(_ sender: AnyObject) {
        print("Record button was pressed...")
        recordingLabel.text = "Recording in progress"
        updateRecordingButtons(recordBtnEnabled: false)
        
        let dirPath = NSSearchPathForDirectoriesInDomains(.documentDirectory,.userDomainMask, true)[0] as String
        let recordingName = "recordedVoice.wav"
        let pathArray = [dirPath, recordingName]
        let filePath = NSURL.fileURL(withPathComponents: pathArray)
        print(filePath)
        
        let session = AVAudioSession.sharedInstance()
        try! session.setCategory(AVAudioSessionCategoryPlayAndRecord)
        
        try! audioRecorder = AVAudioRecorder(url: filePath!, settings: [:])
        audioRecorder.delegate = self
        audioRecorder.isMeteringEnabled = true
        audioRecorder.prepareToRecord()
        audioRecorder.record()
    }
    
    @IBAction func stopRecording(_ sender: AnyObject) {
        print("Recording finished")
        recordingLabel.text = "Recordning Finished"
        updateRecordingButtons(recordBtnEnabled: true)
        
        audioRecorder.stop()
        let session = AVAudioSession.sharedInstance()
        try! session.setActive(false)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        recordButton.isEnabled = true
        stopRecordButton.isEnabled = false
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        print("viewWillAppear Called")
    }
    
    func updateRecordingButtons(recordBtnEnabled: Bool){
        recordButton.isEnabled = recordBtnEnabled
        stopRecordButton.isEnabled = !recordBtnEnabled
        recordingLabel.text = recordBtnEnabled ? tapToRecord : recordInProgress
    }
    
    func audioRecorderDidFinishRecording(_ recorder: AVAudioRecorder, successfully flag: Bool){
        print("Audio Recording Finished")
        if flag {
            self.performSegue(withIdentifier: "stopRecording", sender: audioRecorder.url)
        } else {
            print("Recording failed")
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if (segue.identifier == "stopRecording") {
            let playSoundsVC = segue.destination as! PlaySoundsViewController
            let recordedAudioURL = sender as! URL
            playSoundsVC.recordedAudioURL = recordedAudioURL
        }
    }
}

