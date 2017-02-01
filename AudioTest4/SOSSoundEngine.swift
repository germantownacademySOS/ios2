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
    
    var mapCephs = [String: Cephalopod]()
    var mapPlayers = [String: AVAudioPlayer]()
    var mapSounds = [String: NSDataAsset]()
    
    func silenceAllSounds() {
        for cephPod in mapCephs {
            
            cephPod.value.fadeOut()
            
            //avPlayer.value.setVolume( 0, fadeDuration: 1)
            //avPlayer.value.pause()
        }
    }
    
    func playSound(named nameOfAudioFileInAssetCatalog: String, atVolume newVolume: Float, panned: Float = 0) throws {
        
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
            
            if let ceph = mapCephs[nameOfAudioFileInAssetCatalog] {
                
                // if volume is zero make sure we pause the sound
                if newVolume == 0
                { ceph.fadeOut() }
                else {

                    if let player = mapPlayers[nameOfAudioFileInAssetCatalog] {
                        let oldVolume = player.volume
                        
                        if( !player.isPlaying ) { player.play() }
                        player.pan = panned
                        
                        ceph.fade(fromVolume: Double(oldVolume), toVolume: Double(newVolume))
                    }
                    
                }
                
            }
            else {
                let newPlayer = try AVAudioPlayer(data: (mapSounds[nameOfAudioFileInAssetCatalog]?.data)!)
                mapPlayers[nameOfAudioFileInAssetCatalog] = newPlayer
                mapCephs[nameOfAudioFileInAssetCatalog] = Cephalopod(player: newPlayer)
                newPlayer.volume = 0
                newPlayer.numberOfLoops = 0 // will loop forever
                newPlayer.pan = panned
                newPlayer.setVolume( newVolume, fadeDuration: 1)
                newPlayer.play()
            }
            
        } catch {
            print("error initializing AVAudioPlayer")
        }
    }
    
}

