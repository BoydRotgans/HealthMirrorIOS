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
import CSV


var listOfVideos = ["Tandenpoetsen", "Douchen", "Gezicht wassen"]
var listOfVideoPath = ["example-1", "example-2", "example-3"]

class ViewController: UIViewController, UIGestureRecognizerDelegate, AVPlayerViewControllerDelegate {
    

    @IBOutlet weak var TypeSwitch: UISegmentedControl!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var doneSelection: UIButton!
    @IBOutlet weak var Standby: UIView!
    
    // audio recording
    var recordingSession: AVAudioSession!
    var whistleRecorder: AVAudioRecorder!
    var playAudio: AVAudioPlayer!
    
    
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
        
        // set delegates
        self.tableView.delegate = self
        self.tableView.dataSource = self
        self.tableView.allowsSelection = true
        self.tableView.reloadData()
        
        // Direct Switch to func switchIsChanged
        let animationState = UserDefaults.standard.bool(forKey: "animationStatus") || false
        TypeSwitch.addTarget(self, action: #selector(switchIsChanged), for: UIControl.Event.valueChanged)
        if(animationState) {
            TypeSwitch.selectedSegmentIndex = 1;
        } else {
            TypeSwitch.selectedSegmentIndex = 0;
        }
        let font = UIFont.systemFont(ofSize: 36)
        TypeSwitch.setTitleTextAttributes([NSAttributedString.Key.font: font], for: .normal)
        
        doneSelection.addTarget(self, action: #selector(pressedDoneSelection), for: .touchUpInside)
        self.view.addSubview(doneSelection)
        
        // audio recording session
        recordingSession = AVAudioSession.sharedInstance()
        do {
            try recordingSession.setCategory(.playAndRecord, mode: .default)
            try recordingSession.setActive(true)
            recordingSession.requestRecordPermission() { [unowned self] allowed in
                DispatchQueue.main.async {
                    if allowed {
                        //self.loadRecordingUI()
                    } else {
                        // failed to record!
                    }
                }
            }
        } catch {
            // failed to record!
        }
        
        // record audio when ViewController is active
        startRecording()
        
    }
    
    @objc func appMovedToBackground() {
        print("closed")
        finishRecording(success: true)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        NotificationCenter.default.addObserver(self, selector: #selector(self.viewWasDone), name: NSNotification.Name("viewDidDisappearNow"), object: nil)
        
        let hasRating = UserDefaults.standard.bool(forKey: "hasRating")
        if(hasRating) {
            self.tableView.reloadData()
        }
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name("viewDidDisappearNow"), object: nil)
    }
    
    @objc func pressedDoneSelection() {
        finishRecording(success: true)
    }
    
    @objc func switchIsChanged(switchButton: UISegmentedControl) {
        if switchButton.selectedSegmentIndex == 1 {
            UserDefaults.standard.set(true, forKey: "animationStatus")
        } else {
            UserDefaults.standard.set(false, forKey: "animationStatus")
        }
    }
    
    func checkVideoType(id: Int) -> String {
        
        // check from UserDefaults if Switch of Animation is ON or OFF
        var name = listOfVideoPath[id]
        if let animationSwitch = UserDefaults.standard.string(forKey: "animationStatus") {
            if animationSwitch == "1" {
                name = "\(listOfVideoPath[id])-animation"
            }
        }
        
        return name
    }
    
    func playVideo(id: Int) {
        
        let closeInFullscreen = UIButton()
        closeInFullscreen.frame = CGRect(x: 20, y: 20, width: 50, height: 50)
        closeInFullscreen.setTitle("X", for: .normal)
        closeInFullscreen.setTitleColor(UIColor.white, for: .normal)
        closeInFullscreen.addTarget(self, action: #selector(videoDidEnd), for: .touchUpInside)
        
        if let path = Bundle.main.path(forResource: checkVideoType(id: id), ofType: "mp4") {
            let video = AVPlayer(url: URL(fileURLWithPath: path))
            let videoPlayer = myVideoPlayer()
            videoPlayer.player = video
            videoPlayer.showsPlaybackControls = false
            videoPlayer.contentOverlayView?.addSubview(closeInFullscreen)
            videoPlayer.delegate = self
            
            
            present(videoPlayer, animated: true, completion: {
                print("play")
                video.play()
                self.startTimer()
                
           
                // Save video name to UserDefaults
                UserDefaults.standard.set(listOfVideos[id], forKey: "video")
            })
            

            NotificationCenter.default.addObserver(forName: .AVPlayerItemDidPlayToEndTime, object: video.currentItem, queue: .main) {_ in
                // loop video
                video.seek(to: CMTime.zero)
                video.play()
            }
        }
        
    }
        

    @objc func viewWasDone() {
        
         self.pause()
         self.terminateTimerAndSave()
         print("video ended fullscreen")

         // show Rating Short
         let storyBoard: UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
         let nextViewController = storyBoard.instantiateViewController(withIdentifier: "RatingShort")
         self.present(nextViewController, animated:true, completion:nil)
    }
    


    @objc func videoDidEnd(notification: NSNotification, didFinishWith result: NSNotification, error: Error?) {
        self.pause()
        self.terminateTimerAndSave()
        print("video ended")
        self.dismiss(animated: true, completion: nil)

        // show Rating Card
        let storyBoard: UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
        let nextViewController = storyBoard.instantiateViewController(withIdentifier: "RatingShort")
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
    
    func readCSVFile(id: Int, withReload: Bool) -> Int {
        // csv data path
        let path = getDocumentsDirectory()
        let fileURL = path.appendingPathComponent("trackingData.csv")
        
        var checkPlays = 0
        let currentSessionID = UserDefaults.standard.string(forKey: "sessionID") ?? "no sessionID data"
        
        // read csv
        let readStream = InputStream(url: fileURL)!
        
        let exists = FileManager.default.fileExists(atPath: fileURL.path)
        
        if exists {
            let readCSV = try! CSVReader(stream: readStream, hasHeaderRow: true)

            while readCSV.next() != nil {
                let sessionID = readCSV["sessionID"]!
                let video = readCSV["video"]!
                if sessionID == currentSessionID && video == listOfVideos[id] {
                    checkPlays += 1
                }
            }
        }
        
        return checkPlays
    }
}

extension ViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return(listOfVideos.count)
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell(style: UITableViewCell.CellStyle.default, reuseIdentifier: "tableCell")
        cell.textLabel?.text = listOfVideos[indexPath.row]
        cell.textLabel?.font = .systemFont(ofSize: 50.0)
        
        let checkVideoPlays = UILabel.init(frame: CGRect(x:UIScreen.main.bounds.width - 70.0, y:40.0, width:50.0, height: 43.5))
        checkVideoPlays.textAlignment = NSTextAlignment.right
        checkVideoPlays.textColor = UIColor(named: "customGreen")
        
        let count = self.readCSVFile(id: indexPath.row, withReload: false)
        var title = ""
        if(count>0) {
            title = "✓"
        }
        
        checkVideoPlays.text = String(title)
        
        checkVideoPlays.font = .systemFont(ofSize: 50.0)
        
        cell.addSubview(checkVideoPlays)
        return(cell)
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        UserDefaults.standard.set(false, forKey: "hasRating")
        
        let now = Date()
        let formatter = DateFormatter()
        formatter.timeZone = TimeZone.current
        formatter.dateFormat = "yyyy-MM-dd_HH-mm-ss"
        let timestamp = formatter.string(from: now)
        
        UserDefaults.standard.set(timestamp, forKey: "startVideoPlayTimestamp")
        print("startVideoPlayTimestamp is \(timestamp)")
        
        print("selected \(indexPath.row) -> \(listOfVideos[indexPath.row])")
        self.playVideo(id: indexPath.row)
    }
}
