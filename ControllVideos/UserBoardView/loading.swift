//
//  loading.swift
//  ControllVideos
//
//  Created by Ferdinand Sorg on 30.01.20.
//  Copyright © 2020 Ferdinand Sorg. All rights reserved.
//

import Foundation
import UIKit

fileprivate var aView: UIView?
//fileprivate var vSpinner : UIView?

extension UserBoardViewController {
    
    func startLoading(onSuccess success:() -> Void) {

//        aView = UIView(frame: self.view.bounds)
//        aView?.backgroundColor = UIColor.init(red: 0.0, green: 0.0, blue: 0.0, alpha: 0.5)
//
//        let ai = UIActivityIndicatorView()
//        ai.style = .large
//        ai.color = .white
//        ai.center = aView!.center
//        ai.startAnimating()
//        aView?.addSubview(ai)
//        self.view.addSubview(aView!)
        
//        print("start loading")
//        self.generateZipFile()
//        success()
    }

    func endLoading(success: Bool) {
        
//        if success {
//            aView?.removeFromSuperview()
//            aView = nil
//
//            print("end loading")
//        }
        
    }
    
    
    
    
//    func startLoading(onView : UIView) {
//        let spinnerView = UIView.init(frame: onView.bounds)
//        spinnerView.backgroundColor = UIColor.init(red: 0.5, green: 0.5, blue: 0.5, alpha: 0.5)
//        let ai = UIActivityIndicatorView.init(style: .whiteLarge)
//        ai.startAnimating()
//        ai.center = spinnerView.center
//
//        DispatchQueue.main.async {
//            spinnerView.addSubview(ai)
//            onView.addSubview(spinnerView)
//        }
//
//        vSpinner = spinnerView
//    }
//
//    func endLoading() {
//        DispatchQueue.main.async {
//            vSpinner?.removeFromSuperview()
//            vSpinner = nil
//        }
//    }
}
