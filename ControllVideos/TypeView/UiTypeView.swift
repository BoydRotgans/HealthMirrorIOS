//
//  UiTypeView.swift
//  ControllVideos
//
//  Created by Boyd Rotgans on 23/01/2020.
//  Copyright © 2020 Ferdinand Sorg. All rights reserved.
//

import UIKit

class UiTypeView: UIViewController {
    
    @IBOutlet weak var MirrorButton: UIButton!
    @IBOutlet weak var StandButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
 
        MirrorButton.addTarget(self, action: #selector(clickMirror), for: .touchUpInside)
        StandButton.addTarget(self, action: #selector(clickStand), for: .touchUpInside)
    }
    
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
