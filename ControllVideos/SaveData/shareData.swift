//
//  shareData.swift
//  ControllVideos
//
//  Created by Ferdinand Sorg on 22.01.20.
//  Copyright © 2020 Ferdinand Sorg. All rights reserved.
//

import Foundation
import UIKit

extension UserBoardViewController {
    
    
    
    // share Data with UIActivityViewController
    
    @IBAction func share(sender: AnyObject) {
        
        generateZipFile()
        
//        self.textInput = "generate Zip"
        
        let ZipFileURL = UserDefaults.standard.string(forKey: "ZipFileURL") ?? "no ZipFile exist"
        let fileURL = NSURL(fileURLWithPath: ZipFileURL)
        
        if FileManager.default.fileExists(atPath: fileURL.path!) {
            print("document exist")
            
            let activityViewController: UIActivityViewController = UIActivityViewController(activityItems: [fileURL], applicationActivities: nil)
            activityViewController.popoverPresentationController?.barButtonItem = sender as? UIBarButtonItem
            
            self.present(activityViewController, animated: true, completion: nil)
        }
        else {
            print("document was not found")
        }
    }
}
