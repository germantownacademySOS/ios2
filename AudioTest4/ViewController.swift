//
//  ViewController.swift
//  AudioTest4
//
//  Created by Scott Fraser on 10/19/16.
//  Copyright © 2016 Scott Fraser. All rights reserved.
//

import UIKit
import CoreLocation
import SnapKit

class ViewController: UIViewController {

    @IBOutlet weak var openOtherPOCViewButton: UIButton!
    
    let streamer = StreamPlayer()
    
    let locationManager = CLLocationManager()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        
        loadSnapKit()
        
        locationManager.requestWhenInUseAuthorization()
        locationManager.delegate = self
        
        // @todo I AM HERE - why is this Failed monitoring region Optional("test beacon"): The operation couldn’t be completed. (kCLErrorDomain error 5.)

        
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


    @IBAction func didTouchSound1Button(_ sender: UIButton) {
        streamer.playSound( sender.currentTitle!)
    }
    
    @IBAction func openOtherPOCView(_ sender: UIButton) {
        self.performSegue(withIdentifier: "openOtherPOCView", sender: self)
    }
    
    func loadSnapKit() {
        openOtherPOCViewButton.snp.makeConstraints { make in
            make.bottom.equalToSuperview()
            make.centerX.equalToSuperview()
        }
    }
    
}


extension ViewController : CLLocationManagerDelegate {
    
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
        print(">>> Started monitoring!!!")
    }
    
    func stopMonitoringItem(item: BeaconInfo) {
        let beaconRegion = beaconRegionWithItem(item: item)
        locationManager.stopMonitoring(for: beaconRegion)
        locationManager.stopRangingBeacons(in: beaconRegion)
        print(">>> STOPPED monitoring!!!")
    }
    
    func locationManager(_ manager: CLLocationManager, monitoringDidFailFor region: CLRegion?, withError error: Error) {
        print("Failed monitoring region \(region?.identifier): \(error.localizedDescription)")
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("Location manager failed: \(error.localizedDescription)")
    }
    
    func locationManager(_ manager: CLLocationManager, didRangeBeacons beacons: [CLBeacon], in region: CLBeaconRegion) {
            // print(">>> didRangeBeacons in \(region.proximityUUID)")
            for beacon in beacons {
                
                print("FOUND BEACON: \(beacon.proximityUUID) \(nameForProximity(proximity: beacon.proximity)) rssi:\(beacon.rssi))")
                
                // see what's up with the beacons in range...
                // @todo I AM HERE - https://www.raywenderlich.com/101891/ibeacons-tutorial-ios-swift
        }
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
