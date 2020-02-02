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
    
    // Outlets
    @IBOutlet weak var startTrackingButton: WKInterfaceButton!
    @IBOutlet weak var stopTrackingButton: WKInterfaceButton!
    
    // Actions
    @IBAction func startTrackingButtonPressed() {
    }
    @IBAction func stopTrackingButtonPressed() {
    }
}
