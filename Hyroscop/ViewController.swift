//
//  ViewController.swift
//  Hyroscop
//
//  Created by Mikhail Lutskiy on 01.09.2018.
//  Copyright © 2018 Mikhail Lutskii. All rights reserved.
//

import UIKit
import CoreMotion
import CoreLocation
import Alamofire
import NMAKit
import ObjectMapper

class ViewController: UIViewController, CLLocationManagerDelegate {
    
    let motionManager = CMMotionManager()
    let locationManager = CLLocationManager()
    let uuid = UUID().uuidString
    @IBOutlet weak var imageView: UIImageView!
    
    var speedGlobal = 0.0
    var latitude = 0.0
    var longitude = 0.0
    
    var pinsCurrent = [NMAClusterLayer]()
    @IBOutlet weak var segmentControl: UISegmentedControl!
    
    @IBAction func changeSegmentControl(_ sender: Any) {
        if segmentControl.selectedSegmentIndex == 0 {
            imageView.isHidden = true
        } else {
            imageView.isHidden = false
        }
    }
    
    @IBAction func pitAction(_ sender: Any) {
        
    }
    @IBOutlet weak var warningView: UIView!
    @IBOutlet weak var mapView: NMAMapView!
    @IBOutlet weak var warningTextLabel: UILabel!
    
    @objc func showAlert () {
        warningView.isHidden = false
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        print(uuid)
        
        warningView.isHidden = true
        
        NotificationCenter.default.addObserver(self, selector: #selector(showAlert), name: .pit, object: nil)


        if motionManager.isGyroAvailable {
            motionManager.deviceMotionUpdateInterval = 0.5
            motionManager.startDeviceMotionUpdates()
            
            motionManager.startGyroUpdates(to: OperationQueue.current!) { (gyroData, error) in
                self.outputRotationData(rotation: (gyroData?.rotationRate)!)
                if error != nil {
                    print(error)
                }
            }
        }
        
        
        locationManager.requestAlwaysAuthorization()
        
        if CLLocationManager.locationServicesEnabled() {
            locationManager.delegate = self
            locationManager.desiredAccuracy = kCLLocationAccuracyBest
            locationManager.startUpdatingLocation()
        }
        
        
        mapView.trafficDisplayFilter = .veryHigh
        mapView.positionIndicator.isVisible = true
        mapView.positionIndicator.isAccuracyIndicatorVisible = true
        mapView.set(geoCenter: NMAGeoCoordinates(latitude: 44.008913, longitude: 39.183174), animation: .none)
        
//        if (NMANavigationManager.sharedInstance().navigationState == .idle) {
//            NMANavigationManager.sharedInstance().map = self.mapView;
//            let error = NMANavigationManager.sharedInstance().startTracking(.car)
//            if (error != nil) {
//                print(error)
////                button.setTitle("Stop Tracking", for:[])
//            }
//        }
//
        Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(addPins), userInfo: nil, repeats: true)
        
        //addPins()
    }
    
    func outputRotationData(rotation:CMRotationRate) {
        if ScoringClass.shared.addDotToArray(dot: rotation.z) {
            let params: Parameters = ["uuid": uuid, "x": rotation.x, "y": rotation.y, "z": rotation.z, "latitude": latitude, "longitude":longitude, "speed":speedGlobal]
            Alamofire.request(URL(string: "http://sochi.bigbadbird.ru/sochi/public/logs/add")!, method: .post, parameters: params).response { (response) in
                //print(response)
            }
        }
//        let x = String(format: "Rotation X: %.4f", rotation.x)
//
//        print(x)
//
//        let y = String(format: "Rotation Y: %.4f", rotation.y)
//
//        print(y)
//
//        let z = String(format: "Rotation Z: %.4f", rotation.z)
//
//        print(z)
        //print(rotation)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @objc func addPins() {
        Alamofire.request(URL(string: "http://sochi.bigbadbird.ru/sochi/public/logs/get")!).responseJSON { (response) in
            if let JSON = response.result.value as? [String:AnyObject] {
            let data = Mapper<Model>().mapArray(JSONObject:JSON["data"])
                for cluster in self.pinsCurrent {
                    self.mapView.remove(clusterLayer: cluster)
                }
                self.pinsCurrent = [NMAClusterLayer]()
                print(JSON["data"])
            print(data)
            for pin in data! {
                print(pin)
                let mm = NMAMapMarker(geoCoordinates: NMAGeoCoordinates(latitude: Double(pin.latitude)!, longitude: Double(pin.longitude)!), image: #imageLiteral(resourceName: "golf-hole-and-flag"))
                let c = NMAClusterLayer()
                c.addMarker(mm)
                self.pinsCurrent.append(c)
                self.mapView.add(clusterLayer: c)
                //self.mapView.add(mapObject: mm)
                //print(data)
            }
            }
        }
        //mapView.clea
    }

    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let location = locations.first {
            latitude = location.coordinate.latitude
            longitude = location.coordinate.longitude
            print(location.coordinate)
        }
        var speed: CLLocationSpeed = CLLocationSpeed()
        speed = locationManager.location!.speed
        speedGlobal = speed * 3.6
        print(String(format: "%.0f km/h", speed * 3.6))
    }
    
    // If we have been deined access give the user the option to change it
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        if(status == CLAuthorizationStatus.denied) {
            showLocationDisabledPopUp()
        }
    }
    
    // Show the popup to the user if we have been deined access
    func showLocationDisabledPopUp() {
        let alertController = UIAlertController(title: "Background Location Access Disabled",
                                                message: "In order to deliver pizza we need your location",
                                                preferredStyle: .alert)
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        alertController.addAction(cancelAction)
        
        let openAction = UIAlertAction(title: "Open Settings", style: .default) { (action) in
            if let url = URL(string: UIApplicationOpenSettingsURLString) {
                UIApplication.shared.open(url, options: [:], completionHandler: nil)
            }
        }
        alertController.addAction(openAction)
        
        self.present(alertController, animated: true, completion: nil)
    }
    

}

