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

class ViewController: UIViewController, UIGestureRecognizerDelegate, AVPlayerViewControllerDelegate {

    @IBOutlet weak var TypeSwitch: UISegmentedControl!
    @IBOutlet weak var doneSelection: UIButton!
    @IBOutlet weak var Standby: UIView!

    // audio recording
    var recordingSession: AVAudioSession!
    var whistleRecorder: AVAudioRecorder!
    var playAudio: AVAudioPlayer!


    //timer
    var thumbnails: Array<UIImage> = []
    var start = Date()
    var stopped: Date?
    var resumed: Date?
    var finished: Date?
    var timer: Timer?
    var timeElapsed = Double()
    var timeStopped = Double()
    
    //

    @IBOutlet var collectionViewThumbnail: UICollectionView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // set CollectionViewThumbnail
        collectionViewThumbnail.delegate = self
        collectionViewThumbnail.dataSource = self

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
        
        // generate thumbnails
        storeThumbnails()

        // record audio when ViewController is active
        startRecording()
        
        let notificationCenter = NotificationCenter.default
        
        // detect if app goes in background
        notificationCenter.addObserver(self, selector: #selector(appMovedToBackground), name: UIApplication.didEnterBackgroundNotification, object: nil)
        // detect if app goes in foreground
        notificationCenter.addObserver(self, selector: #selector(appMovedToForeground), name: UIApplication.willEnterForegroundNotification, object: nil)
    }
    
    // finish all running task when app get closed
    @objc func appMovedToBackground(_ application: UIApplication) {
        print("App moved to Background!")
        resetCheckPlays()
        finishRecording(success: true)
    }
    
    // reload collection view after ending the app
    @objc func appMovedToForeground(_ application: UIApplication) {
        print("App moved to Foreground!")
        self.collectionViewThumbnail.reloadData()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        NotificationCenter.default.addObserver(self, selector: #selector(self.viewWasDone), name: NSNotification.Name("viewDidDisappearNow"), object: nil)

        let hasRating = UserDefaults.standard.bool(forKey: "hasRating")
        if(hasRating) {
            self.collectionViewThumbnail.reloadData()
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
        
        self.collectionViewThumbnail.reloadData()
        storeThumbnails()
    }

    func checkVideoType(id: Int) -> String {

        // check from UserDefaults if Switch of Animation is ON or OFF
        var name = "\(getVideoMeta(id: id)[2])_video"
        
        
        print("1 \(name)")
        if let animationSwitch = UserDefaults.standard.string(forKey: "animationStatus") {
            if animationSwitch == "1" {
                name = "\(getVideoMeta(id: id)[2])_animatie"
                print("2 \(name)")
            }
        }

        return name
    }

    func playVideo(id: Int) {

        let closeInFullscreen = UIButton()
        closeInFullscreen.frame = CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height)
        closeInFullscreen.setTitle("", for: .normal)
        closeInFullscreen.setTitleColor(UIColor.white, for: .normal)
        closeInFullscreen.addTarget(self, action: #selector(videoDidEnd), for: .touchUpInside)

        if let path = Bundle.main.path(forResource: checkVideoType(id: id), ofType: "mp4") {
            let video = AVPlayer(url: URL(fileURLWithPath: path))
            let videoPlayer = myVideoPlayer()
            video.isMuted = true
            videoPlayer.player = video
            videoPlayer.showsPlaybackControls = false
            videoPlayer.contentOverlayView?.addSubview(closeInFullscreen)
            videoPlayer.delegate = self


            present(videoPlayer, animated: true, completion: {
                print("play")
                video.play()
                self.startTimer()


                // Save videoName to UserDefaults
                let videoName:String = self.getVideoMeta(id: id)[1] as! String
                UserDefaults.standard.set(videoName, forKey: "video")
                
                // Save videoID to UserDefaults
                UserDefaults.standard.set(id, forKey: "videoID")
                
                // check Video Plays
                var checkPlays: Int = UserDefaults.standard.integer(forKey: "checkPlays-\(videoName)")
                checkPlays = checkPlays + 1
                
                // update Video Plays
                UserDefaults.standard.set(checkPlays, forKey: "checkPlays-\(videoName)")
                
                
                print("3 \(videoName)")
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

//    func readCSVFile(id: Int, withReload: Bool) -> Int {
//        // csv data path
//        let path = getDocumentsDirectory()
//        let fileURL = path.appendingPathComponent("trackingData.csv")
//
//        var checkPlays = 0
//        let currentSessionID = UserDefaults.standard.string(forKey: "sessionID") ?? "no sessionID data"
//
//        // read csv
//        let readStream = InputStream(url: fileURL)!
//
//        let exists = FileManager.default.fileExists(atPath: fileURL.path)
//
//        if exists {
//            let readCSV = try! CSVReader(stream: readStream, hasHeaderRow: true)
//
//            while readCSV.next() != nil {
//                let sessionID = readCSV["sessionID"]!
//                let video = readCSV["video"]!
//                let currentVideoName:String = getVideoMeta(id: id)[1] as! String
//                print("4 \(currentVideoName)")
//
//                if sessionID == currentSessionID && video == currentVideoName {
//                    checkPlays += 1
//                }
//            }
//        }
//
//        return checkPlays
//    }
    
    func storeThumbnails()  {
        let total = countVideo() - 1
        
        // clean already stored images
        if thumbnails.count > 0  {
            thumbnails.removeAll()
        }
        
        // fill it again
        for n in 0...total {
            thumbnails.append(generateThumbnail(id: n))
        }
    }
    
    
    // reset after session is done -> executed in saveQuestionsCSV.swift
    func resetCheckPlays() {
        let total = self.countVideo() - 1
        
        for n in 0...total {
            let videoName = getVideoMeta(id: n)[1]
            UserDefaults.standard.set(0, forKey: "checkPlays-\(videoName)")
        }
        print("reseted all checkPlays")
    }
}

extension ViewController {
    func getVideoMeta(id: Int) -> Array<Any> {
        // csv data path
        let path = Bundle.main.path(forResource: "videoMeta", ofType: "csv")
        let fileURL = URL(fileURLWithPath: path!)

        // read csv
        let readStream = InputStream(url: fileURL)!

        let exists = FileManager.default.fileExists(atPath: fileURL.path)
        
        var videoRow: Array<Any> = []

        if exists {
            let readCSV = try! CSVReader(stream: readStream, hasHeaderRow: true)

            while readCSV.next() != nil {
                let numberID: Int = Int(readCSV["id"]!)!
                if numberID == id {
                    videoRow.append(id)
                    videoRow.append(readCSV["videoName"]!)
                    videoRow.append(readCSV["videoPath"]!)
                    videoRow.append(readCSV["question"]!)
                }
            }
        }

        return videoRow
    }
    
    func countVideo() -> Int {
        // csv data path
        let path = Bundle.main.path(forResource: "videoMeta", ofType: "csv")
        let fileURL = URL(fileURLWithPath: path!)

        // read csv
        let readStream = InputStream(url: fileURL)!

        let exists = FileManager.default.fileExists(atPath: fileURL.path)
        
        var count: Int = 0

        if exists {
            let readCSV = try! CSVReader(stream: readStream, hasHeaderRow: true)

            while readCSV.next() != nil {
                count = Int(readCSV["id"]!)!
            }
        }

        return count + 1
    }
}
