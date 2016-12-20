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
    
    let locationManager = CLLocationManager()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        locationManager.requestWhenInUseAuthorization()
        locationManager.delegate = self
        
        // just for testing - hard coded start of monitoring a beacon
        startMonitoringItem(item: BeaconInfo(name: "test beacon",
                                             uuid: UUID( uuidString: "E621E1F8-C36C-495A-93FC-0C247A3E6E5F")!,
                                                majorValue: 123,
                                                minorValue: 456))
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


    @IBAction func didTouchSound1Button(_ sender: UIButton) {
        streamer.playSound( sender.currentTitle!)
    }
    
    
}

extension ViewController : CLLocationManagerDelegate {
    
    private func beaconRegionWithItem(item:BeaconInfo) -> CLBeaconRegion {
        let beaconRegion = CLBeaconRegion(proximityUUID: item.uuid,
                                          major: item.majorValue,
                                          minor: item.minorValue,
                                          identifier: item.name)
        return beaconRegion
    }
    
    func startMonitoringItem(item: BeaconInfo) {
        let beaconRegion = beaconRegionWithItem(item: item)
        locationManager.startMonitoring(for: beaconRegion)
        locationManager.startRangingBeacons(in: beaconRegion)
    }
    
    func stopMonitoringItem(item: BeaconInfo) {
        let beaconRegion = beaconRegionWithItem(item: item)
        locationManager.stopMonitoring(for: beaconRegion)
        locationManager.stopRangingBeacons(in: beaconRegion)
    }
    
    func locationManager(_ manager: CLLocationManager, monitoringDidFailFor region: CLRegion?, withError error: Error) {
        print("Failed monitoring region: \(error.localizedDescription)")
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("Location manager failed: \(error.localizedDescription)")
    }
    
    func locationManager(_ manager: CLLocationManager, didRangeBeacons beacons: [CLBeacon], in region: CLBeaconRegion) {
            for beacon in beacons {
                
                // see what's up with the beacons in range...
                // @todo I AM HERE - https://www.raywenderlich.com/101891/ibeacons-tutorial-ios-swift
        }
    }
    
}
