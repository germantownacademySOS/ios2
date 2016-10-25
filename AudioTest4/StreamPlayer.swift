//
//  StreamPlayer.swift
//  AudioTest4
//
//  Created by Scott Fraser on 10/19/16.
//  Copyright © 2016 Scott Fraser. All rights reserved.
//

import Foundation
import AVFoundation
import UIKit

class StreamPlayer {
    
    var cephalopod: Cephalopod?
    
    var mapPlayers = [String: AVAudioPlayer]()
    
    func toggleSound(named nameOfAudioFileInAssetCatalog: String) {

        if let sound = NSDataAsset(name: nameOfAudioFileInAssetCatalog) {
            
            do {
                try! AVAudioSession.sharedInstance().setCategory(AVAudioSessionCategoryPlayback)
                try! AVAudioSession.sharedInstance().setActive(true)
                
                
                if let oldPlayer = mapPlayers[nameOfAudioFileInAssetCatalog] {
                    
                    if oldPlayer.isPlaying {
                        cephalopod = Cephalopod(player: oldPlayer)
                        cephalopod?.fadeOut(duration: 1, velocity: 2)
                        // oldPlayer.pause()
                    }
                    else {
                        cephalopod = Cephalopod(player: oldPlayer)
                        cephalopod?.fadeIn(duration: 1, velocity: 2)
                        oldPlayer.play()
                    }
                }
                else {
                    let newPlayer = try AVAudioPlayer(data: sound.data)
                    mapPlayers[nameOfAudioFileInAssetCatalog] = newPlayer
                    cephalopod = Cephalopod(player: newPlayer)
                    cephalopod?.fadeIn(duration: 1, velocity: 2)
                    newPlayer.play()
                }
                
            } catch {
                print("error initializing AVAudioPlayer")
                }
            }
    }
    
    
    
    func test1() {
        toggleSound(named: "m21-Test1")
    }
    
    func test2() {
        toggleSound(named: "m21-Test2")
    }
    
    func test3() {
        toggleSound(named: "m21-Test3")
    }
}
