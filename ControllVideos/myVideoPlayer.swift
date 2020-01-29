//
//  myVideoPlayer.swift
//  ControllVideos
//
//  Created by Boyd Rotgans on 29/01/2020.
//  Copyright © 2020 Ferdinand Sorg. All rights reserved.
//

import Foundation
import AVFoundation
import UIKit
import AVKit

class myVideoPlayer: AVPlayerViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        print("did go away")
        
        NotificationCenter.default.post(name: NSNotification.Name("viewDidDisappearNow"), object: nil)
    }
    
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
