//
//  ViewController.swift
//  ControllVideos
//
//  Created by Ferdinand Sorg on 20.01.20.
//  Copyright © 2020 Ferdinand Sorg. All rights reserved.
//

import UIKit
import AVKit
import AVFoundation
import MessageUI

var listOfVideos = ["Toothbrush", "Showering", "Face Washing"]
var listOfVideoPath = ["example-1", "example-2", "example-3"]

class ViewController: UIViewController, UIGestureRecognizerDelegate {
    
    @IBOutlet weak var nextPage: UIButton!
    @IBOutlet weak var animationSwitch: UISwitch!
    @IBOutlet weak var standbyButton: UIButton!
    @IBOutlet weak var saveToCSV: UIButton!
    
    @IBOutlet weak var Standby: UIView!
    
    //timer
    var start = Date()
    var stopped: Date?
    var resumed: Date?
    var finished: Date?
    var timer: Timer?
    var timeElapsed = Double()
    var timeStopped = Double()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        var buttons = [UIButton]()
        var button: UIButton
        
        var y = 100
        for (index, video) in listOfVideos.enumerated() {
            
            button = UIButton(type: UIButton.ButtonType.system) as UIButton
            button.frame = CGRect(x: 80, y: y, width: 250, height: 50)
            button.setTitle("\(video)", for: .normal)
            button.backgroundColor = .systemYellow
            button.setTitleColor(UIColor.white, for: .normal)
            button.tag = index
            button.addTarget(self, action: #selector(self.buttonTapped), for: .touchUpInside)
            self.view.addSubview(button)
            buttons.append(button)
            
            y = y + 75
        }
        
        // Direct Switch to func switchIsChanged
        let animationStatus:Bool = UserDefaults.standard.bool(forKey: "animationStatus")
        animationSwitch.setOn(animationStatus, animated: false)
        animationSwitch.addTarget(self, action: #selector(switchIsChanged), for: UIControl.Event.valueChanged)
        self.view.addSubview(animationSwitch)
        
        saveToCSV.addTarget(self, action: #selector(executeSaveCSV), for: .touchUpInside)
        self.view.addSubview(saveToCSV)
        
        
        // set Standby Button
//        standbyButton.addTarget(self, action: #selector(checkStandby), for: .touchUpInside)
//        self.view.addSubview(standbyButton)
        
    }
    
//    @objc func checkStandby() {
//       let currentTime = Date()
//        
//        func formatter(time: Date) -> String {
//            let formatter = DateFormatter()
//            formatter.dateFormat = "HH"
//            return formatter.string(from: time)
//        }
//        
//        let cTimeHH:Int = Int(formatter(time: currentTime))!
//        
//        print("time is \(cTimeHH)")
//        
//        if cTimeHH > 07 && cTimeHH < 14 {
//            print("it is \(cTimeHH) -> NOT Standby")
//            
//        } else {
//            print("it is \(cTimeHH) -> Standby")
//            
//            // show Standby
//            let storyBoard: UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
//            let nextViewController = storyBoard.instantiateViewController(withIdentifier: "Standby")
//            self.present(nextViewController, animated:true, completion:nil)
//        }
//    }
    
    @objc func buttonTapped(sender: UIButton) {
        playVideo(id: sender.tag)
    }
    
    // call function in saveData/saveSCV
    @objc func executeSaveCSV(sender: UIButton) {
        checkAllData()
    }
    
    @objc func switchIsChanged(switchButton: UISwitch) {
        var animationStatus:Bool
        if switchButton.isOn {
            animationStatus = true
            UserDefaults.standard.set(animationStatus, forKey: "animationStatus")
        } else {
            animationStatus = false
            UserDefaults.standard.set(animationStatus, forKey: "animationStatus")
        }
    }
    
    
    func playVideo(id: Int) {
        
        let closeInFullscreen = UIButton()
        closeInFullscreen.frame = CGRect(x: 20, y: 20, width: 50, height: 50)
        closeInFullscreen.setTitle("X", for: .normal)
        closeInFullscreen.setTitleColor(UIColor.white, for: .normal)
        closeInFullscreen.addTarget(self, action: #selector(videoDidEnd), for: .touchUpInside)
        
        
        // check from UserDefaults if Switch of Animation is ON or OFF
        var name = listOfVideoPath[id]
        if let animationSwitch = UserDefaults.standard.string(forKey: "animationStatus") {
            if animationSwitch == "1" {
                name = "\(listOfVideoPath[id])-animation"
            }
        }
        
        if let path = Bundle.main.path(forResource: name, ofType: "mp4") {
            let video = AVPlayer(url: URL(fileURLWithPath: path))
            let videoPlayer = AVPlayerViewController()
            videoPlayer.player = video
            videoPlayer.showsPlaybackControls = false
            videoPlayer.contentOverlayView?.addSubview(closeInFullscreen)
            
            present(videoPlayer, animated: true, completion: {
                video.play()
                self.startTimer()
                
                // Save video name to UserDefaults
                UserDefaults.standard.set(listOfVideos[id], forKey: "video")
            })
            
            NotificationCenter.default.addObserver(forName: .AVPlayerItemDidPlayToEndTime, object: video.currentItem, queue: .main) {
                // loop video
                [weak self] _ in
                video.seek(to: CMTime.zero)
                video.play()
            }
            
//            NotificationCenter.default.addObserver(self, selector: #selector(videoDidEnd), name: NSNotification.Name.AVPlayerItemDidPlayToEndTime, object: nil)
        }
        
    }
    
    @objc func videoDidEnd(notification: NSNotification, didFinishWith result: NSNotification, error: Error?) {
        
        print("notification is \(notification)")
        print("error is \(error)")
        print("result is \(result)")
        
        self.pause()
        self.terminateTimerAndSave()
        print("video ended")
        self.dismiss(animated: true, completion: nil)
        
        // show Rating Card
        let storyBoard: UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
        let nextViewController = storyBoard.instantiateViewController(withIdentifier: "RatingCard")
        self.present(nextViewController, animated:true, completion:nil)
    }

    func startTimer() {
        start = Date()
        timer = Timer.scheduledTimer(withTimeInterval: 0.01, repeats: true, block: {_ in
            self.performActiveTimer()
        })
    }

    func reStartTimer() {
        resumed = Date()
        if let stop = stopped, let resume = resumed {
            timeStopped = timeStopped + (resume.timeIntervalSince1970 - stop.timeIntervalSince1970)
        }
        timer = Timer.init(timeInterval: 0.01, repeats: true, block: { (this) in
            self.performActiveTimer()
        })

    }

    func pause() {
        timer?.invalidate()
        stopped = Date()
    }

    func performActiveTimer() {
        timeElapsed = Date().timeIntervalSince1970 - start.timeIntervalSince1970
//        print("timer: \(timeElapsed)")
    }
    
    func stringFromTimeInterval(interval: TimeInterval) -> NSString {
        
        let ti = NSInteger(interval)
        let ms = Int((interval.truncatingRemainder(dividingBy: 1)) * 1000)
        let seconds = ti % 60
        let minutes = (ti / 60) % 60
        let hours = (ti / 3600)
        
        return NSString(format: "%0.2d:%0.2d:%0.2d.%0.3d",hours,minutes,seconds,ms)
    }
    
    func terminateTimerAndSave() {
        let now = Date()
        finished = now
        timeElapsed = now.timeIntervalSince1970 - start.timeIntervalSince1970
        let finalTime = stringFromTimeInterval(interval: timeElapsed)
        print("final time: \(finalTime)")
        
        // Save Duration in UserDefaults
        UserDefaults.standard.set(finalTime, forKey: "duration")
    }
}
