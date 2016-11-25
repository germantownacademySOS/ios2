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
                    
                    let oldCephalopod = mapCephalopods[nameOfAudioFileInAssetCatalog]
                    oldCephalopod?.stop()
                    
                    // @todo add flag to indicate if ramping up or down
                    
                    if oldPlayer.isPlaying {
                        oldCephalopod?.fadeOut(duration: 1, velocity: 2)
                        // oldPlayer.pause()
                    }
                    else {
                        oldCephalopod?.fadeIn(duration: 1, velocity: 2)
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
    
    func playSound( _ named : String ) {
        toggleSound(named: named)
    }
}
