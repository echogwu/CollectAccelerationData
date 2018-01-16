//
//  ViewController.swift
//  CollectAccelerationData
//
//  Created by  Echo Wu on 1/16/18.
//  Copyright © 2018  Echo Wu. All rights reserved.
//

import UIKit
import CoreMotion
import SwiftyJSON

class ViewController: UIViewController {

    let motion: CMMotionManager = CMMotionManager()
    let gravityFilename = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0].appendingPathComponent("gravity.txt")
    let userAccFilename = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0].appendingPathComponent("user.txt")
    
    func getDocumentsDirectory() -> URL {
        let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        let documentsDirectory = paths[0]
        return documentsDirectory
    }
    
    func startAccelerator(){
        do{
        try FileManager.default.removeItem(at: gravityFilename)
        try FileManager.default.removeItem(at: userAccFilename)
        try FileManager.default.removeItem(at: FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0].appendingPathComponent("output.txt"))
        }catch{
            print("oops, removing files went wrong")
        }
        if motion.isAccelerometerAvailable{
            motion.deviceMotionUpdateInterval = 1.0 / 60.0   // 60HZ
            motion.startDeviceMotionUpdates(using: .xArbitraryZVertical, to: .main, withHandler: { (deviceMotion, error) in
                guard let deviceMotion = deviceMotion else { return }
                self.collectData(from: deviceMotion)
                
            })
        }
    }
    
    func collectData(from deviceMotion: CMDeviceMotion){
        let gravity = [deviceMotion.gravity.x, deviceMotion.gravity.y, deviceMotion.gravity.z].description
        let userAcceleration = [deviceMotion.userAcceleration.x, deviceMotion.userAcceleration.y, deviceMotion.userAcceleration.z].description
        
        write(gravity, toFile: gravityFilename)
        write(userAcceleration, toFile: userAccFilename)

    }
    
    func write(_ dataString: String, toFile fileName: URL){
        do{
            let fileHandle = try FileHandle(forWritingTo: fileName)
            fileHandle.seekToEndOfFile()
            fileHandle.write(dataString.data(using: .utf8)!)
            fileHandle.closeFile()
        }catch{
            print("oops, filehandle is wrong")
        }
    }
    
    func readData(){
        do{
        let data = try Data(contentsOf: gravityFilename)
            let attibutedString = try NSAttributedString(data: data, documentAttributes: nil)
            let fullText = attibutedString.string
            print(fullText)
        }catch{
            print("oops")
        }
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
//        readData()
        startAccelerator()
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

