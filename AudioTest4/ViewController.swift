//
//  ViewController.swift
//  AudioTest4
//
//  Created by Scott Fraser on 10/19/16.
//  Copyright © 2016 Scott Fraser. All rights reserved.
//

import UIKit
import CoreLocation

class ViewController: UIViewController {
    
    let streamer = SOSSoundEngine()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    @IBAction func didTouchSound1Button(_ sender: UIButton) {
        do {
            // this used to turn the sound on and off
            try streamer.playSound( named: sender.currentTitle!, atVolume: 1 )
        } catch SOSError.fileAssetNotFound(let fileName){
            print("Could not find file " + fileName)
        } catch {
            print("Unknown error")
        }
    }
    
}


