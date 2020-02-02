//
//  PracticeShotsInterfaceController.swift
//  PerfectJumpshot WatchKit Extension
//
//  Created by Austin Vigo on 2/1/20.
//  Copyright © 2020 austin-keith. All rights reserved.
//

import UIKit
import WatchKit
import Foundation
import CoreMotion

class PracticeShotsInterfaceController: WKInterfaceController {
    
    // Outlets
    @IBOutlet weak var startEvaluatingShotButton: WKInterfaceButton!
    @IBOutlet weak var stopEvaluatingShotButton: WKInterfaceButton!
    @IBOutlet weak var feedbackLabel: WKInterfaceLabel!
    
    // Class members
    let motionManager = CMMotionManager()
    let validThreshold: Double = 0.80
    var readings: [AccelerometerReading] = []
    
    override func awake(withContext context: Any?) {
        super.awake(withContext: context)

        startEvaluatingShotButton.setTitle("Take Shot")
        stopEvaluatingShotButton.setTitle("Evaluate Shot")
        feedbackLabel.setHidden(true)

    }
    
    // The user is taken a shot
    @IBAction func startEvaluatingShotButtonPressed() {
            
        // UI changes
        feedbackLabel.setHidden(true)
        startEvaluatingShotButton.setHidden(true)
        stopEvaluatingShotButton.setHidden(false)
        
        // Start reading values and putting in array
        if motionManager.isAccelerometerAvailable == true {
            motionManager.startAccelerometerUpdates(to: OperationQueue.main) { (data, error) in
                
                // create reading and add to the array
                var newReading = AccelerometerReading(posx: 0.0,
                                                      posy: 0.0,
                                                      posz: 0.0,
                                                      negx: 0.0,
                                                      negy: 0.0,
                                                      negz: 0.0)
                
                // Grab the x, y, z values from the data
                let xReading: Double = data?.acceleration.x ?? 0.0
                let yReading: Double = data?.acceleration.y ?? 0.0
                let zReading: Double = data?.acceleration.z ?? 0.0
                
                // Update new reading values
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
                
                // Add it to the array
                self.readings.append(newReading)
            }
            
            
        }
        
    }
    
    @IBAction func stopEvaluatingShotButtonPressed() {
        
        startEvaluatingShotButton.setHidden(false)
        stopEvaluatingShotButton.setHidden(true)
        
        // Check if the current reading is in the range and evaluate
        if motionManager.isAccelerometerActive == true {
            
            motionManager.stopAccelerometerUpdates()
            
            // These values will be compared to the pref accel
            var maxX: Double = 0.0
            var maxY: Double = 0.0
            var maxZ: Double = 0.0
            var minX: Double = 0.0
            var minY: Double = 0.0
            var minZ: Double = 0.0
            
            // Parse readings
            for reading in readings {
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
            
            // Get the user's overall readings and compare
            let currentReading = AccelerometerReading(posx: maxX,
                                                      posy: maxY,
                                                      posz: maxZ,
                                                      negx: minX,
                                                      negy: minY,
                                                      negz: minZ)
            
            //Check if the recorded data is within the valid threshold of the preferred acceleration reading
            if  currentReading.posx <= InterfaceController.prefAccelReading.posx + validThreshold &&
                currentReading.posx >= InterfaceController.prefAccelReading.posx - validThreshold &&
                currentReading.posy <= InterfaceController.prefAccelReading.posy + validThreshold &&
                currentReading.posy >= InterfaceController.prefAccelReading.posy - validThreshold &&
                currentReading.posz <= InterfaceController.prefAccelReading.posz + validThreshold &&
                currentReading.posz >= InterfaceController.prefAccelReading.posz - validThreshold &&
                currentReading.negx >= InterfaceController.prefAccelReading.negx - validThreshold &&
                currentReading.negx <= InterfaceController.prefAccelReading.negx + validThreshold &&
                currentReading.negy >= InterfaceController.prefAccelReading.negy - validThreshold &&
                currentReading.negy <= InterfaceController.prefAccelReading.negy + validThreshold &&
                currentReading.negz >= InterfaceController.prefAccelReading.negz - validThreshold &&
                currentReading.negz <= InterfaceController.prefAccelReading.negz + validThreshold {
                
                feedbackLabel.setText("GOOD")
            }
            else {
                feedbackLabel.setText("BAD")
            }
            
            // Give the user their feedback
            feedbackLabel.setHidden(false)
            readings = []
        }
    }
}
