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

var listOfVideos = ["toothbrush", "showering", "faceWashing"]
var listOfVideoPath = ["example-1", "example-2", "example-3"]

class ViewController: UIViewController {
    
    @IBOutlet weak var nextPage: UIButton!
    @IBOutlet weak var animationSwitch: UISwitch!
    @IBOutlet weak var standbyButton: UIButton!
    
    @IBOutlet weak var Standby: UIView!
    
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
        animationSwitch.addTarget(self, action: #selector(switchIsChanged), for: UIControl.Event.valueChanged)
        self.view.addSubview(animationSwitch)
        
//        checkStandby()
        
        
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
    
    @objc func switchIsChanged(switchButton: UISwitch) {
        
        var animationStatus:Bool = true
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
        closeInFullscreen.addTarget(self, action: #selector(exitFullscreenVideo), for: .touchUpInside)
        
        
        // check from UserDefaults if Switch of Animation is ON or OFF
        var name = listOfVideoPath[id]
        if let animationSwitch = UserDefaults.standard.string(forKey: "animationStatus") {
            if animationSwitch == "1" {
                name = "\(listOfVideoPath[id])-animation"
            }
        }
        
        if let path = Bundle.main.path(forResource: name, ofType: "mp4")
        {
            let video = AVPlayer(url: URL(fileURLWithPath: path))
            let videoPlayer = AVPlayerViewController()
            videoPlayer.player = video
            videoPlayer.showsPlaybackControls = false
            videoPlayer.contentOverlayView?.addSubview(closeInFullscreen)
            
            present(videoPlayer, animated: true, completion: {
                video.play()
            })
            
            NotificationCenter.default.addObserver(self, selector: #selector(videoDidEnd), name: NSNotification.Name.AVPlayerItemDidPlayToEndTime, object: nil)
        }
    }
    
    @objc func videoDidEnd(notification: NSNotification) {
        print("video ended automatically")
        self.dismiss(animated: true, completion: nil)
    }
    
    @objc func exitFullscreenVideo(sender: AnyObject) {
        self.dismiss(animated: true, completion: nil)
        print("video forced to quit ended")
        
        // show Rating Card
        let storyBoard: UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
        let nextViewController = storyBoard.instantiateViewController(withIdentifier: "RatingCard")
        self.present(nextViewController, animated:true, completion:nil)
    }
}

class newPage: UIViewController, UITableViewDataSource, UITableViewDelegate {
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return listOfVideos.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell(style: UITableViewCell.CellStyle.default, reuseIdentifier: "cell")
        cell.textLabel?.text = listOfVideos[indexPath.row]
        return cell
    }
}

class RatingCard: UIViewController {
    
    @IBOutlet weak var floatRatingView: FloatRatingView!
    @IBOutlet weak var liveLabel: UILabel!
    @IBOutlet weak var updatedLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Reset float rating view's background color
        floatRatingView.backgroundColor = UIColor.clear

        /** Note: With the exception of contentMode, type and delegate,
         all properties can be set directly in Interface Builder **/
        floatRatingView.delegate = self
        floatRatingView.contentMode = UIView.ContentMode.scaleAspectFit
        floatRatingView.type = .wholeRatings

        // Labels init
        liveLabel.text = String(format: "%.2f", self.floatRatingView.rating)
        updatedLabel.text = String(format: "%.2f", self.floatRatingView.rating)
    }
}

extension RatingCard: FloatRatingViewDelegate {
    
    func floatRatingView(_ ratingView: FloatRatingView, isUpdating rating: Double) {
        liveLabel.text = String(format: "%.2f", self.floatRatingView.rating)
    }
    
    func floatRatingView(_ ratingView: FloatRatingView, didUpdate rating: Double) {
        updatedLabel.text = String(format: "%.2f", self.floatRatingView.rating)
    }
    
}

class Standby: UIViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        print("hello standby")
    }
}
