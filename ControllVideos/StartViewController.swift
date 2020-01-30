//
//  StartViewController.swift
//  ControllVideos
//
//  Created by Boyd Rotgans on 30/01/2020.
//  Copyright © 2020 Ferdinand Sorg. All rights reserved.
//

import UIKit

class StartViewController: UIViewController {
    
    @IBOutlet weak var startButton: UIButton!
    
    // check Status Bar
    var isStatusBarHidden: Bool = false
    override var prefersStatusBarHidden: Bool {
        return self.isStatusBarHidden
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(checkStandby), userInfo: nil, repeats: true)
    }
        
    @objc func checkStandby() {
    
            let currentTime = Date()
    
    
            func formatter(time: Date) -> String {
                let formatter = DateFormatter()
                formatter.dateFormat = "HH"
                return formatter.string(from: time)
            }
    
            let cTimeHH:Int = Int(formatter(time: currentTime))!
    
            print("time is \(cTimeHH)")
    
            if cTimeHH > 07 && cTimeHH < 14 {
                print("it is \(cTimeHH) -> NOT Standby")
                startButton.titleLabel?.textColor = .link
                self.isStatusBarHidden = false
            } else {
                print("it is \(cTimeHH) -> Standby")
                startButton.titleLabel?.textColor = .black
                self.isStatusBarHidden = true
            }
        
            UIView.animate(withDuration: 0.3) {
                self.setNeedsStatusBarAppearanceUpdate()
            }
        }


}
