//
//  ViewController.swift
//  iBeacon-Project22
//
//  Created by Alex Perucchini on 6/25/19.
//  Copyright © 2019 Alex Perucchini. All rights reserved.
//

import UIKit
import CoreLocation
import SpriteKit

class ViewController: UIViewController, CLLocationManagerDelegate {

    @IBOutlet var distanceReading: UILabel!
    var locationManager: CLLocationManager?
    var showAlert = false
    var circle: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        locationManager = CLLocationManager()
        locationManager?.delegate = self
        locationManager?.requestAlwaysAuthorization()
        
        view.backgroundColor = .white

        circle = UIView(frame: CGRect(x: 0, y: 0, width: 256, height: 256))
        circle.center.x = view.center.x
        circle.center.y = view.center.y
        circle.layer.cornerRadius = 128
        circle.layer.borderWidth = 0
        circle.layer.zPosition = -1
        view.addSubview(circle)
    }
    
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        if status == .authorizedAlways {
            // can the beacon be detected
            if CLLocationManager.isMonitoringAvailable(for: CLBeaconRegion.self) {
                if CLLocationManager.isRangingAvailable() {
                    // do stuff
                    startScanning()
                }
            }
        }
    }

    func startScanning() {
        let uuid = UUID(uuidString: "5A4BCFCE-174E-4BAC-A814-092E77F6B7E5")!
        let beaconRegion = CLBeaconRegion(proximityUUID: uuid, major: 123, minor: 456, identifier: "MyBeacon")
        
        locationManager?.startMonitoring(for: beaconRegion)
        locationManager?.startRangingBeacons(in: beaconRegion)
    }
    
//    If we receive any beacons from this method, we'll pull out the first one and use its proximity property to call our update(distance:) method and redraw the user interface. If there aren't any beacons, we'll just use .unknown, which will switch the text back to "UNKNOWN" and make the background color gray.
    
    func locationManager(_ manager: CLLocationManager, didRangeBeacons beacons: [CLBeacon], in region: CLBeaconRegion) {
        
        if let beacon = beacons.first {
            update(distance: beacon.proximity)
        } else {
            update(distance: .unknown)
        }
        
        print(beacons.first)
    }
    
    func locationManager(_ manager: CLLocationManager, didEnterRegion region: CLRegion) {
        showAlert = true
        print("Enter region: \(region)")
        if showAlert {
            let ac = UIAlertController(title: "Enter Region", message: "\(region)", preferredStyle: .alert)
            let okAction = UIAlertAction(title: "OK", style: .default)
            ac.addAction(okAction)
            showAlert = false
            present(ac, animated: true)
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didExitRegion region: CLRegion) {
        showAlert = true
        print("Exit region: \(region)")
        if showAlert {
            let ac = UIAlertController(title: "Exit Region", message: "\(region)", preferredStyle: .alert)
            let okAction = UIAlertAction(title: "OK", style: .default)
            ac.addAction(okAction)
            showAlert = false
            present(ac, animated: true)
        }
    }
    
    func update(distance: CLProximity) {
        UIView.animate(withDuration: 0.9) {

            switch distance {
                
            case .far:
                self.circle.backgroundColor = UIColor.red
                self.distanceReading.textColor = .gray
                self.distanceReading.text = "FAR"
                self.circle.transform = CGAffineTransform(scaleX: 0.8, y: 0.8)
            
            case .near:
                self.circle.backgroundColor = UIColor.yellow
                self.distanceReading.textColor = .gray
                self.distanceReading.text = "NEAR"
                self.circle.transform = CGAffineTransform(scaleX: 1.2, y: 1.2)
                
            case .immediate:
                self.circle.backgroundColor = UIColor.green
                self.distanceReading.textColor = .gray
                self.distanceReading.text = "IMMEDIATE"
                self.circle.transform = CGAffineTransform(scaleX: 1.4, y: 1.4)
           
            default:
                self.circle.backgroundColor = UIColor.gray
                self.distanceReading.text = "UNKNOWN"
                self.distanceReading.textColor = .white
                self.circle.transform = CGAffineTransform(scaleX: 0.8, y: 0.8)
            }
        }
    }
}

