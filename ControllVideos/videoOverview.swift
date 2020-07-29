//
//  videoOverview.swift
//  ControllVideos
//
//  Created by Ferdinand Sorg on 10.02.20.
//  Copyright © 2020 Ferdinand Sorg. All rights reserved.
//

import Foundation
import UIKit
import AVFoundation

// Collection View Thumbnail

extension ViewController {
    
    func generateThumbnail(id: Int) -> UIImage {

        var thumbnail: UIImage?
        
        if let path = Bundle.main.path(forResource: checkVideoType(id: id), ofType: "mp4") {
            let fileURL = URL(fileURLWithPath: path)
            let avAsset = AVURLAsset(url: fileURL, options: nil)
            let imageGenerator = AVAssetImageGenerator(asset: avAsset)
            imageGenerator.appliesPreferredTrackTransform = true
            
            do {
                thumbnail = try UIImage(cgImage: imageGenerator.copyCGImage(at: CMTime(seconds: 0, preferredTimescale: 1), actualTime: nil))
            } catch let e as NSError {
                print("Error: \(e.localizedDescription)")
            }
        }
        
        return thumbnail!
    }
    
}

extension ViewController: UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return countVideo()
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        let flowayout = collectionViewLayout as? UICollectionViewFlowLayout
        let space: CGFloat = (flowayout?.minimumInteritemSpacing ?? 0.0) + (flowayout?.sectionInset.left ?? 0.0) + (flowayout?.sectionInset.right ?? 0.0)
        let heightOfLabel = 70.0
        
        let width:CGFloat = (collectionViewThumbnail.frame.size.width - space) / 2.0
        let height:CGFloat = (1024/768)*width + CGFloat(heightOfLabel)
        
        return CGSize(width: width, height: height)
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "thumbnailCell", for: indexPath) as! ThumbnailCell
        let videoName:String = getVideoMeta(id: indexPath.row)[1] as! String
        
        cell.thumbnailImg.image = thumbnails[indexPath.row]
        
        cell.videoCaption.text = videoName
        
        var title = ""
        
        let count = UserDefaults.standard.integer(forKey: "checkPlays-\(videoName)")
        
        if(count > 0) {
            title = "✓"
        }
        
        cell.checkVideoPlay.text = title
        cell.checkVideoPlay.textColor = UIColor(named: "customGreen")

        return cell
    }   
    
        

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        print("you selected \(indexPath.item)")
        
        print("videoMeta is \(getVideoMeta(id: indexPath.item))")
        
        UserDefaults.standard.set(false, forKey: "hasRating")

        let now = Date()
        let formatter = DateFormatter()
        formatter.timeZone = TimeZone.current
        formatter.dateFormat = "yyyy-MM-dd_HH-mm-ss"
        let timestamp = formatter.string(from: now)

        UserDefaults.standard.set(timestamp, forKey: "startVideoPlayTimestamp")
        print("startVideoPlayTimestamp is \(timestamp)")

        print("selected \(indexPath.row) -> \(getVideoMeta(id: indexPath.row)[1])")
        self.playVideo(id: indexPath.row)
    }
    
}
