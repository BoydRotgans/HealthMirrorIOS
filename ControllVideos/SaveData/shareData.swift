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
        
        let fileManager = FileManager.default
        let path = NSSearchPathForDirectoriesInDomains(.documentDirectory,.userDomainMask,true).first!
        var sourceURL = URL(fileURLWithPath: path)
        sourceURL.appendPathComponent("")

        print("sourceURL is \(sourceURL)")

        var destinationURL = URL(fileURLWithPath: NSTemporaryDirectory(), isDirectory: true)
        destinationURL.appendPathComponent("dataPackage.zip")
        
        do {
            try fileManager.zipItem(at: sourceURL, to: destinationURL, shouldKeepParent: false)

            print("zip is generated")
        } catch {
            print(error)
        }
        
        
        
        
        
        
        
        
        
        
        
        
        print("hey toolbar item")
        
//        let path = getDocumentsDirectory()
//        let questionData = path.appendingPathComponent("questionData.csv").path
//        let trackingData = path.appendingPathComponent("trackingData.csv").path

//        let url = URL(string: trackingData)
//        print(url!.path,"\n")
        
        
        
        let file1 = NSURL(fileURLWithPath: destinationURL.path)
//        let file2 = NSURL(fileURLWithPath: questionData)

        // Create the Array which includes the files you want to share
        var filesToShare = [Any]()

        // Add the path of the file to the Array
        filesToShare.append(file1)
//        filesToShare.append(file2)
        
        
        

        if FileManager.default.fileExists(atPath: file1.path!) {
            print("document exist")

//            let documento = NSData(contentsOfFile: url!.path)
//            let random = "Hello this is a String."
            
            
            
            
            let activityViewController: UIActivityViewController = UIActivityViewController(activityItems: filesToShare, applicationActivities: nil)

            print("build activityViewController")


            activityViewController.popoverPresentationController?.barButtonItem = sender as? UIBarButtonItem

            print("popover activityViewController")

            self.present(activityViewController, animated: true, completion: nil)
        }
        else {
            print("document was not found")
        }
        
        
    }
}
