//
//  InterfaceController.swift
//  PerfectJumpshot WatchKit Extension
//
//  Created by Austin Vigo on 2/1/20.
//  Copyright © 2020 austin-keith. All rights reserved.
//

import WatchKit
import Foundation
import CoreMotion

struct AccelerometerReading {
    var posx: Double
    var posy: Double
    var posz: Double
}

class InterfaceController: WKInterfaceController {

    override func awake(withContext context: Any?) {
        super.awake(withContext: context)
        
        // Configure interface objects here.
    }
    
    override func willActivate() {
        // This method is called when watch view controller is about to be visible to user
        super.willActivate()
    }
    
    override func didDeactivate() {
        // This method is called when watch view controller is no longer visible
        super.didDeactivate()
    }
    
    // Class Variables
    let motionManager = CMMotionManager()
    var prefAccelReading = AccelerometerReading(posx: 0.0, posy: 0.0, posz: 0.0)
    var accelReadings: [AccelerometerReading] = []
    
    // Outlets
    @IBOutlet weak var startTrackingButton: WKInterfaceButton!
    @IBOutlet weak var stopTrackingButton: WKInterfaceButton!
    
    // Actions
    @IBAction func startTrackingButtonPressed() {
        if motionManager.isAccelerometerAvailable == true {
            motionManager.accelerometerUpdateInterval = 0.2
            motionManager.startAccelerometerUpdates(to: OperationQueue.main) { (data, error) in
                
                //Grab the x, y, z values from the data
                let xVal: Double = data?.acceleration.x ?? 0.0
                let yVal: Double = data?.acceleration.y ?? 0.0
                let zVal: Double = data?.acceleration.z ?? 0.0
                
                //Create new reading and add to the list
                let newReading = AccelerometerReading(posx: xVal, posy: yVal, posz: zVal)
                self.accelReadings.append(newReading)
            }
        }
    }
    
    
    @IBAction func stopTrackingButtonPressed() {
        if motionManager.isAccelerometerActive == true {
            
            //Stop tracking jumpshot data
            motionManager.stopAccelerometerUpdates()
            
            //get the preferred x y z val
            var maxX: Double = 0.0
            var maxY: Double = 0.0
            var maxZ: Double = 0.0
            for reading in accelReadings {
                if reading.posx > maxX {
                    maxX = reading.posx
                }
                if reading.posy > maxY {
                    maxY = reading.posy
                }
                if reading.posz > maxZ {
                    maxZ = reading.posz
                }
            }
            
            //Set the users preffered values
            prefAccelReading.posx = maxX
            prefAccelReading.posy = maxY
            prefAccelReading.posz = maxZ
            
            print(prefAccelReading)
        }
    }
}
