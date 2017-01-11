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
    
    let streamer = StreamPlayer()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
                
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


    @IBAction func didTouchSound1Button(_ sender: UIButton) {
        streamer.playSound( sender.currentTitle!)
    }
    
    
}


