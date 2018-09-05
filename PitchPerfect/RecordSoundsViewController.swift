//
//  RecordSoundsViewController.swift
//  PitchPerfect
//
//  Created by Phani A on 9/19/17.
//  Copyright © 2017 Practice. All rights reserved.
//

import UIKit
import AVFoundation

class RecordSoundsViewController: UIViewController, AVAudioRecorderDelegate {

    @IBOutlet weak var recordingLabel: UILabel!
    @IBOutlet weak var recordButton: UIButton!
    @IBOutlet weak var stopRecording: UIButton!
    
    // MARK: AVAudioRecorderDelegate needs to inherit inorder to use AVAudioRecorder.
    var audioRecorder: AVAudioRecorder!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        stopRecording.isEnabled = false
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func recordAudio(_ sender: Any) {
        controlContext("Recording in Progress", false, true)
        
        // MARK: Prepare the file path
        let dirPath = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0] as String
        let recordingName = "recordedVoice.wav"
        let pathArray = [dirPath, recordingName]
        let filePath =  URL(string: pathArray.joined(separator: "/"))
        
        //Use the device session
        let session = AVAudioSession.sharedInstance()
        try! session.setCategory(AVAudioSessionCategoryPlayAndRecord, with:	.defaultToSpeaker)
        
        try! audioRecorder = AVAudioRecorder(url: filePath!, settings: [:])
        
        audioRecorder.delegate = self
        audioRecorder.isMeteringEnabled = true
        audioRecorder.prepareToRecord()
        audioRecorder.record()
    }

    @IBAction func stopRecording(_ sender: Any) {
        controlContext("Stop Recording", true, false)
        
        audioRecorder.stop()
        let audioSession = AVAudioSession.sharedInstance()
        try! audioSession.setActive(false)
    }
    
    // MARK: Common function to manage the control state.
    func controlContext(_ displayText: String, _ recordButtonState: Bool, _ stopButtonState: Bool){
        recordingLabel.text = displayText
        recordButton.isEnabled = recordButtonState
        stopRecording.isEnabled = stopButtonState
    }
    
    func audioRecorderDidFinishRecording(_ recorder: AVAudioRecorder, successfully flag: Bool) {
         if flag {
            performSegue(withIdentifier: "stopRecording", sender: audioRecorder.url)
        }
        else{
            recordingLabel.text = "Recording failed"
        }
    }
    
    // MARK: After finish recording. Pass the recorded URL to destination controller using segue programmatically.
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "stopRecording"{
            let playSoundsVC = segue.destination as! PlaySoundsViewController
            let recordedAudioURL = sender as! URL
            
            playSoundsVC.recordedAudioURL = recordedAudioURL
        }
    }
}

