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
    
    let engine = AVAudioEngine()
    
    func test() {
        // first sound
        
        let player = AVAudioPlayerNode()
        //let url = Bundle.main().urlForResource(
        //    "music/JasperJohns", withExtension: "m4a")!
        //
        
        //let assetUrl = Bundle.main().urlForResource("01 Jasper John.mp3", withExtension: nil)!

        // let assetUrl = Bundle.main().urlForResource("01 Jasper John", withExtension: "mp3")!

        // let assetUrl = Bundle.main().urlForResource("JasperJohn", withExtension: "mp3")!
        
        // this works
        //if let assetUrl = Bundle.main().urlForResource("song", withExtension: "mp3") {
        
        
        if let asset = NSDataAsset(name:"Sound") {
            
            do {
                // Use NSDataAsset's data property to access the audio file stored in Sound
                try player = AVAudioPlayer(data:asset.data, fileTypeHint:"caf")
                // Play the above sound file
                player.play()
            } catch let error as NSError {
                print(error.localizedDescription)
            }
        }
        
        if let assetUrl = Bundle.main().urlForResource("01 Jasper John.mp3", withExtension: nil) {
            
            
        

            print("found it")

            let f = try! AVAudioFile(forReading: assetUrl)
            engine.attach(player)
            // add some effect nodes to the chain
            let effect = AVAudioUnitTimePitch()
            effect.rate = 0.9
            effect.pitch = -300
            engine.attach(effect)
            engine.connect(player, to: effect, format: f.processingFormat)
            let effect2 = AVAudioUnitReverb()
            effect2.loadFactoryPreset(.cathedral)
            effect2.wetDryMix = 40
            engine.attach(effect2)
            engine.connect(effect, to: effect2, format: f.processingFormat)
            // patch last node into engine mixer and start playing first sound
            let mixer = engine.mainMixerNode
            engine.connect(effect2, to: mixer, format: f.processingFormat)
            player.scheduleFile(f, at: nil, completionHandler:nil)
            engine.prepare()
            do {
                try engine.start()
                player.play()
            } catch { return }
            
            // second sound; loop it this time
            if let url2 = Bundle.main().urlForResource(
                "rr9", withExtension: "mp3") {

                let f2 = try! AVAudioFile(forReading: url2)
                let buffer = AVAudioPCMBuffer(
                    pcmFormat: f2.processingFormat, frameCapacity: UInt32(f2.length/3))
                try! f2.read(into: buffer)
                let player2 = AVAudioPlayerNode()
                engine.attach(player2)
                engine.connect(player2, to: mixer, format: f2.processingFormat)
                player2.scheduleBuffer(
                    buffer, at: nil, options: .loops, completionHandler: nil)
                // mix down a little, start playing second sound
                player.pan = -0.5
                player2.volume = 0.5
                player2.pan = 0.5
                player2.play()
                
            }
        }
    }
}
