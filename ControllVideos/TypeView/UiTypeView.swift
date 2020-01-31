//
//  UiTypeView.swift
//  ControllVideos
//
//  Created by Boyd Rotgans on 23/01/2020.
//  Copyright © 2020 Ferdinand Sorg. All rights reserved.
//

import UIKit
import CSV

class UiTypeView: UIViewController {
    
    @IBOutlet weak var MirrorButton: UIButton!
    @IBOutlet weak var StandButton: UIButton!
    
    @IBOutlet weak var countingMirrorLabel: UILabel!
    @IBOutlet weak var countingStandLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        // check csv
        self.calculateSessions()
 
        MirrorButton.addTarget(self, action: #selector(clickMirror), for: .touchUpInside)
        StandButton.addTarget(self, action: #selector(clickStand), for: .touchUpInside)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        self.calculateSessions()
    }
    
    @IBAction func backButtonPressed(_ sender: Any) {
        
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: "startView") as UIViewController
        vc.modalTransitionStyle = .flipHorizontal
        present(vc, animated: true, completion: nil)
        
    }
    
    func calculateSessions() {
            
        // csv data path
        let path = getDocumentsDirectory()
        let fileURL = path.appendingPathComponent("trackingData.csv")
        
        var sessionsArrayMirror = [] as [String]
        var sessionsArrayStand = [] as [String]
        
        let currentSelectedUser = UserDefaults.standard.string(forKey: "selectedUser") ?? "no selected user"
        
        // read csv
        let readStream = InputStream(url: fileURL)!
        let exists = FileManager.default.fileExists(atPath: fileURL.path)
        
        if exists {
            let readCSV = try! CSVReader(stream: readStream, hasHeaderRow: true)

            while readCSV.next() != nil {
                let user = readCSV["user"]
                let location = readCSV["location"]
                let sessionID = readCSV["sessionID"]!
                
                if(user == currentSelectedUser) {
                    if(location == "mirror") {
                        if(!sessionsArrayMirror.contains(sessionID)) {
                            sessionsArrayMirror.append(sessionID)
                        }
                    } else if(location == "stand") {
                        if(!sessionsArrayStand.contains(sessionID)) {
                            sessionsArrayStand.append(sessionID)
                        }
                    }
                }
            }
        }
        
//        let margin = 20.0
//        let width = (UIScreen.main.bounds.width - CGFloat(3*margin))/2
        
        countingMirrorLabel.text = "\(sessionsArrayMirror.count) / 10"
        MirrorButton.backgroundColor = .link
        MirrorButton.layer.cornerRadius = 25.0
        
        if( sessionsArrayMirror.count >= 10) {
            countingMirrorLabel.text = "✓ Compleet \(sessionsArrayMirror.count) / 10"
//            countingMirrorLabel.textColor = UIColor(named: "customGreen")
            MirrorButton.backgroundColor = UIColor(named: "customGreen")
        }
        
        countingStandLabel.text = "\(sessionsArrayStand.count) / 10"
        StandButton.backgroundColor = .link
        StandButton.layer.cornerRadius = 25.0
        
        if( sessionsArrayStand.count >= 10) {
            countingStandLabel.text = "✓ Compleet \(sessionsArrayStand.count) / 10"
//            countingStandLabel.textColor = UIColor(named: "customGreen")
            StandButton.backgroundColor = UIColor(named: "customGreen")
            
        }
        
    }
    
//     @objc func backAction() {
//         print("backkkk")
//     }
    
    @objc func clickMirror() {
        UserDefaults.standard.set("mirror", forKey: "selectedType")
        print("mirror")
        openPage()
    }
    
    @objc func clickStand() {
        UserDefaults.standard.set("stand", forKey: "selectedType")
        print("stand")
        openPage()
    }
    
    func openPage() {
        let storyBoard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        let newViewController = storyBoard.instantiateViewController(withIdentifier: "ViewController") as! ViewController
        newViewController.modalPresentationStyle = .fullScreen
        
        self.present(newViewController, animated: true, completion: nil)
    }
    

}
