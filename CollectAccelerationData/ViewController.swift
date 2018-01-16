//
//  ViewController.swift
//  CollectAccelerationData
//
//  Created by  Echo Wu on 1/16/18.
//  Copyright © 2018  Echo Wu. All rights reserved.
//

import UIKit
import CoreMotion
import simd

class ViewController: UIViewController {

    let motion: CMMotionManager = CMMotionManager()
    
    func getDocumentsDirectory() -> URL {
        let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        let documentsDirectory = paths[0]
        return documentsDirectory
    }
    
    func startAccelerator(){
        if motion.isAccelerometerAvailable{
            motion.deviceMotionUpdateInterval = 1.0 / 60.0   // 60HZ
            motion.startDeviceMotionUpdates(using: .xArbitraryZVertical, to: .main, withHandler: { (deviceMotion, error) in
                guard let deviceMotion = deviceMotion else { return }
                self.collectData(from: deviceMotion)
                
            })
        }
    }
    
    func collectData(from deviceMotion: CMDeviceMotion){
        let gravity = [deviceMotion.gravity.x, deviceMotion.gravity.y, deviceMotion.gravity.z]
        let userAcceleration = [deviceMotion.userAcceleration.x, deviceMotion.userAcceleration.y, deviceMotion.userAcceleration.z]
        print("ducument directory: \(getDocumentsDirectory())")
        print("gravity: \(gravity)")
        print("userAcceleration: \(userAcceleration)")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        startAccelerator()
        print(getDocumentsDirectory())
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

