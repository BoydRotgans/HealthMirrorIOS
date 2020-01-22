//
//  SaveInCSV.swift
//  ControllVideos
//
//  Created by Ferdinand Sorg on 20.01.20.
//  Copyright © 2020 Ferdinand Sorg. All rights reserved.
//

import UIKit
import Foundation
import CSV

class SaveInCSV: UIViewController {
    
    var user = ["Suellen", "Rita", "Jamika", "Minh", "Tenesha"]
    var video = ["toothbrush", "showering", "faceWashing"]
    var videoPath = ["example-1", "example-2", "example-3"]
    var duration = [1:12, 5:42, 2:31, 0:40, 2:01]
    
    
    func newFunc() {
        let now = Date()
        let formatter = DateFormatter()
        formatter.timeZone = TimeZone.current
        formatter.dateFormat = "yyyy-MM-dd_HH:mm:ss"
        let dateString = formatter.string(from: now)
        
        print("date is \(dateString)")
    }
    

}
