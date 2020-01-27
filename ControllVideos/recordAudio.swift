//
//  recordAudio.swift
//  ControllVideos
//
//  Created by Ferdinand Sorg on 27.01.20.
//  Copyright © 2020 Ferdinand Sorg. All rights reserved.
//

import Foundation
import AVFoundation
import AVKit

extension ViewController: AVCaptureAudioDataOutputSampleBufferDelegate, AVAudioRecorderDelegate {
    
    func getWhistleURL() -> URL {
        
        // create audio file
        let now = Date()
        let formatter = DateFormatter()
        formatter.timeZone = TimeZone.current
        formatter.dateFormat = "yyyy-MM-dd_HH-mm-ss"
        let timestamp = formatter.string(from: now)
        let audioFileName = "recording-\(timestamp).m4a"
        print("recording time: \(timestamp)")
        
        return getDocumentsDirectory().appendingPathComponent(audioFileName)
    }
    
    
    func startRecording() {
        let audioURL = getWhistleURL()
        print("start Recording")
        
        let settings = [
            AVFormatIDKey: Int(kAudioFormatMPEG4AAC),
            AVSampleRateKey: 16000,
            AVNumberOfChannelsKey: 1,
            AVEncoderAudioQualityKey: AVAudioQuality.high.rawValue
        ]
        
        do {
            whistleRecorder = try AVAudioRecorder(url: audioURL, settings: settings)
            whistleRecorder.delegate = self
            whistleRecorder.record()
        } catch {
            print("done")
            finishRecording(success: false)
        }
    }
    
    func audioRecorderDidFinishRecording(_ recorder: AVAudioRecorder, successfully flag: Bool) {
        if !flag {
            finishRecording(success: false)
        }
    }
    
    func finishRecording(success: Bool) {
        whistleRecorder.stop()
        whistleRecorder = nil
        
        print("finish Recording")
    }
}
