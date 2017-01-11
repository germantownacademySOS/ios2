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
    
    func playSound(named nameOfAudioFileInAssetCatalog: String, atVolume volume: Float) throws {
        
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
                
                // if volume is zero make sure we stop the sound
                if volume == 0
                    { oldPlayer.stop() }
                else {
                    oldPlayer.setVolume( volume, fadeDuration: 1)
                    if( !oldPlayer.isPlaying ) { oldPlayer.play() }
                }

            }
            else {
                let newPlayer = try AVAudioPlayer(data: (mapSounds[nameOfAudioFileInAssetCatalog]?.data)!)
                mapPlayers[nameOfAudioFileInAssetCatalog] = newPlayer
                newPlayer.volume = 0
                newPlayer.play()
                newPlayer.setVolume( volume, fadeDuration: 1)
            }
            
        } catch {
            print("error initializing AVAudioPlayer")
        }
    }
    
}

