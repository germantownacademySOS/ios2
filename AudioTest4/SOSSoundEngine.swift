//
//  SOSSoundEngine.swift
//  AudioTest4
//
//  Created by Scott Fraser on 1/10/17.
//  Copyright © 2017 Scott Fraser. All rights reserved.
//

import Foundation
import AVFoundation
import UIKit
import Cephalopod

class SOSSoundEngine {
    
    var mapPlayers = [String: AVAudioPlayer]()
    var mapSounds = [String: NSDataAsset]()
    
    func silenceAllSounds() {
        for avPlayer in mapPlayers {
            avPlayer.value.setVolume( 0, fadeDuration: 1)
            avPlayer.value.pause()
        }
    }
    
    func playSound(named nameOfAudioFileInAssetCatalog: String, atVolume volume: Float, panned: Float = 0) throws {
        
        // first check to see if we have already loaded this sound
        if mapSounds[nameOfAudioFileInAssetCatalog] == nil {
            guard let sound = NSDataAsset(name: nameOfAudioFileInAssetCatalog) else {
                throw SOSError.fileAssetNotFound(called: nameOfAudioFileInAssetCatalog)
            }
            
            mapSounds[nameOfAudioFileInAssetCatalog] = sound
        }
        
        do {
            try! AVAudioSession.sharedInstance().setCategory(AVAudioSessionCategoryPlayback)
            try! AVAudioSession.sharedInstance().setActive(true)
            
            // check to see if we already have a player for this sound
            
            if let oldPlayer = mapPlayers[nameOfAudioFileInAssetCatalog] {
                
                // if volume is zero make sure we pause the sound
                if volume == 0
                    { oldPlayer.pause() }
                else {
                    oldPlayer.setVolume( volume, fadeDuration: 1)
                    oldPlayer.pan = panned
                    if( !oldPlayer.isPlaying ) { oldPlayer.play() }
                }

            }
            else {
                let newPlayer = try AVAudioPlayer(data: (mapSounds[nameOfAudioFileInAssetCatalog]?.data)!)
                mapPlayers[nameOfAudioFileInAssetCatalog] = newPlayer
                newPlayer.volume = 0
                newPlayer.numberOfLoops = 0 // will loop forever
                newPlayer.pan = panned
                newPlayer.setVolume( volume, fadeDuration: 1)
                newPlayer.play()
            }
            
        } catch {
            print("error initializing AVAudioPlayer")
        }
    }
    
}

