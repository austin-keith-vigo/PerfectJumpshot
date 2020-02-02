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
    var negx: Double
    var negy: Double
    var negz: Double
}

class InterfaceController: WKInterfaceController {

    override func awake(withContext context: Any?) {
        super.awake(withContext: context)
        
        // Configure interface objects here.
        startTrackingButton.setTitle("Start")
        stopTrackingButton.setTitle("Stop")
        nextScreenButton.setTitle("Practice Shots")
        
        initialState()
    }
    
    override func willActivate() {
        initialState()
        // This method is called when watch view controller is about to be visible to user
        super.willActivate()
    }
    
    override func didDeactivate() {
        // This method is called when watch view controller is no longer visible
        super.didDeactivate()
    }
    
    // Class Variables
    let motionManager = CMMotionManager()
    var accelReadings: [AccelerometerReading] = []
    static var prefAccelReading = AccelerometerReading(posx: 0.0,
                                                posy: 0.0,
                                                posz: 0.0,
                                                negx: 0.0,
                                                negy: 0.0,
                                                negz: 0.0)
    
    // Outlets
    @IBOutlet weak var startTrackingButton: WKInterfaceButton!
    @IBOutlet weak var stopTrackingButton: WKInterfaceButton!
    @IBOutlet weak var nextScreenButton: WKInterfaceButton!
    
    // Actions
    @IBAction func startTrackingButtonPressed() {
        
        accelReadings = [] // Reset list
        recordingShotsState() // Make sure the UI elements are reset
        
        if motionManager.isAccelerometerAvailable == true {
            motionManager.accelerometerUpdateInterval = 0.2
            motionManager.startAccelerometerUpdates(to: OperationQueue.main) { (data, error) in
                
                //Create new reading with default values
                var newReading = AccelerometerReading(posx: 0.0,
                                                      posy: 0.0,
                                                      posz: 0.0,
                                                      negx: 0.0,
                                                      negy: 0.0,
                                                      negz: 0.0)
                
                //Grab the x, y, z values from the data
                let xReading: Double = data?.acceleration.x ?? 0.0
                let yReading: Double = data?.acceleration.y ?? 0.0
                let zReading: Double = data?.acceleration.z ?? 0.0
            
                //Initalize the new reading values according to the data
                if xReading > 0 {
                    newReading.posx = xReading
                }
                else {
                    newReading.negx = xReading
                }
            
                if yReading > 0 {
                    newReading.posy = yReading
                }
                else {
                    newReading.negy = yReading
                }
                
                if xReading > 0 {
                    newReading.posz = zReading
                }
                else {
                    newReading.negz = zReading
                }
                
                //add to the list
                self.accelReadings.append(newReading)
            }
        }
    }
    
    
    @IBAction func stopTrackingButtonPressed() {
        if motionManager.isAccelerometerActive == true {
            
            //Stop tracking jumpshot data
            motionManager.stopAccelerometerUpdates()
            
            //get the preferred positive and negative x y z val
            var maxX: Double = 0.0
            var maxY: Double = 0.0
            var maxZ: Double = 0.0
            var minX: Double = 0.0
            var minY: Double = 0.0
            var minZ: Double = 0.0
            
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
                if reading.negx < minX {
                    minX = reading.negx
                }
                if reading.negy < minY {
                    minY = reading.negy
                }
                if reading.negz < minZ {
                    minZ = reading.negz
                }
            }
            
            //Set the users preffered values
            InterfaceController.prefAccelReading.posx = maxX
            InterfaceController.prefAccelReading.posy = maxY
            InterfaceController.prefAccelReading.posz = maxZ
            InterfaceController.prefAccelReading.negx = minX
            InterfaceController.prefAccelReading.negy = minY
            InterfaceController.prefAccelReading.negz = minZ
            
            // Update UI Elements
            nextScreenState()
        }
    }
    
    // Functions to set UI
    func initialState() {
        startTrackingButton.setTitle("Start")
        startTrackingButton.setHidden(false)
        stopTrackingButton.setHidden(true)
        nextScreenButton.setHidden(true)
    }
    
    func recordingShotsState() {
        startTrackingButton.setHidden(true)
        stopTrackingButton.setHidden(false)
        nextScreenButton.setHidden(true)
    }
    
    // The user has recorded data, now they can
    func nextScreenState() {
        startTrackingButton.setTitle("Try Again")
        startTrackingButton.setHidden(false)
        stopTrackingButton.setHidden(true)
        nextScreenButton.setHidden(false)
    }
}
