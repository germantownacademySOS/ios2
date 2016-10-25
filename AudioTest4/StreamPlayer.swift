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
    
    // var cephalopod: Cephalopod?
    
    var mapPlayers = [String: AVAudioPlayer]()
    var mapCephalopods = [String: Cephalopod]()
    
    func toggleSound(named nameOfAudioFileInAssetCatalog: String) {

        if let sound = NSDataAsset(name: nameOfAudioFileInAssetCatalog) {
            
            do {
                try! AVAudioSession.sharedInstance().setCategory(AVAudioSessionCategoryPlayback)
                try! AVAudioSession.sharedInstance().setActive(true)
                
                
                if let oldPlayer = mapPlayers[nameOfAudioFileInAssetCatalog] {
                    
                    let cephalopod = mapCephalopods[nameOfAudioFileInAssetCatalog]
                    
                    if oldPlayer.isPlaying {
                        cephalopod?.fadeOut(duration: 1, velocity: 2)
                        // oldPlayer.pause()
                    }
                    else {
                        cephalopod?.fadeIn(duration: 1, velocity: 2)
                        oldPlayer.play()
                    }
                }
                else {
                    let newPlayer = try AVAudioPlayer(data: sound.data)
                    let newCephalopod = Cephalopod( player: newPlayer )
                    mapPlayers[nameOfAudioFileInAssetCatalog] = newPlayer
                    newPlayer.volume = 0
                    newCephalopod.fadeIn(duration: 1, velocity: 2)
                    mapCephalopods[nameOfAudioFileInAssetCatalog] = newCephalopod
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
