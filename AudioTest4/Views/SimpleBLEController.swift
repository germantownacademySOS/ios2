//
//  SimpleBLEController.swift
//  AudioTest4
//
//  Created by Perry Fraser on 1/9/17.
//  Copyright © 2017 Scott Fraser. All rights reserved.
//

import CoreLocation
import UIKit

class SimpleBLEController: UIViewController {
    
    let locationManager = CLLocationManager()
    
    let soundPlayer = SOSSoundEngine()
    
    @IBOutlet weak var bleInfoLabelOut: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        bleInfoLabelOut.numberOfLines = 4
        bleInfoLabelOut.lineBreakMode = NSLineBreakMode.byWordWrapping
        
        // Do any additional setup after loading the view.
        locationManager.requestWhenInUseAuthorization()
        locationManager.delegate = self
        
        // just for testing - hard coded start of monitoring a beacon
        startMonitoringItem(item: BeaconInfo(name: "test beacon",
                                             // this is uuid and major/minor of example RFDuino programmed to range:
            uuid: UUID( uuidString: "E2C56DB5-DFFB-48D2-B060-D0F5A71096E0")!,
            majorValue: 1234,
            minorValue: 5678))
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destinationViewController.
     // Pass the selected object to the new view controller.
     }
     */
    
}

extension SimpleBLEController : CLLocationManagerDelegate {
    
    private func beaconRegionWithItem(item:BeaconInfo) -> CLBeaconRegion {
        let beaconRegion = CLBeaconRegion(proximityUUID: item.uuid,
                                          //major: item.majorValue,
            //minor: item.minorValue,
            identifier: item.name)
        return beaconRegion
    }
    
    func startMonitoringItem(item: BeaconInfo) {
        let beaconRegion = beaconRegionWithItem(item: item)
        locationManager.startMonitoring(for: beaconRegion)
        locationManager.startRangingBeacons(in: beaconRegion)
        BleLog( "Started Monitoring!!!" )
    }
    
    func stopMonitoringItem(item: BeaconInfo) {
        let beaconRegion = beaconRegionWithItem(item: item)
        locationManager.stopMonitoring(for: beaconRegion)
        locationManager.stopRangingBeacons(in: beaconRegion)
        BleLog( "STOPPED Monitoring!" )
    }
    
    func locationManager(_ manager: CLLocationManager, monitoringDidFailFor region: CLRegion?, withError error: Error) {
        BleLog( "Failed monitoring region \(region?.identifier): \(error.localizedDescription)" )
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        BleLog("Location manager failed: \(error.localizedDescription)")
    }
    
    func locationManager(_ manager: CLLocationManager, didRangeBeacons beacons: [CLBeacon], in region: CLBeaconRegion) {
        // print(">>> didRangeBeacons in \(region.proximityUUID)")
        
        do {
            if (beacons.isEmpty) {
                BleLog("No Beacons nearby")
                try soundPlayer.playSound(named: "m21-Test1", atVolume: 0)
            }
            else {
                for beacon in beacons {
                    
                    BleLog("FOUND BEACON: \(beacon.proximityUUID) \(nameForProximity(proximity: beacon.proximity)) rssi:\(beacon.rssi))")
                    
                    //soundPlayer.playSound(named: "m21-Test1", atVolume: volumeForProximity(proximity: beacon.proximity))
                    
                    if(beacon.proximity == CLProximity.unknown) {
                        try soundPlayer.playSound(named: "m21-Test1", atVolume: 0)
                    }
                    else if(beacon.proximity == CLProximity.immediate) {
                        try soundPlayer.playSound(named: "m21-Test1", atVolume: 1.0)
                    }
                    else {
                        try soundPlayer.playSound(named: "m21-Test1", atVolume: (1 - (Float(-beacon.rssi)/100)))
                    }
                }
            }
        } catch SOSError.fileAssetNotFound(let fileName){
            print("Could not find file " + fileName)
        } catch {
            print("Unknown error")
        }
        
    }
    
    private func BleLog(_ msg: String) {
        bleInfoLabelOut.text = msg
    }
    
}

func ==(item: BeaconInfo, beacon: CLBeacon) -> Bool {
    return ((beacon.proximityUUID.uuidString == item.uuid.uuidString)
        && (Int(beacon.major) == Int(item.majorValue))
        && (Int(beacon.minor) == Int(item.minorValue)))
}

func nameForProximity(proximity: CLProximity) -> String {
    switch proximity {
    case .unknown:
        return "Unknown"
    case .immediate:
        return "Immediate"
    case .near:
        return "Near"
    case .far:
        return "Far"
    }
}

func volumeForProximity(proximity: CLProximity) -> Float {
    switch proximity {
    case .unknown:
        return 0
    case .immediate:
        return 1
    case .near:
        return 0.6
    case .far:
        return 0.1
    }
}

