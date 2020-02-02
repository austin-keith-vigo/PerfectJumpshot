//
//  ViewController.swift
//  PerfectJumpshot
//
//  Created by Austin Vigo on 2/1/20.
//  Copyright © 2020 austin-keith. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        makeCall()
    }

    func makeCall() {
        let session = URLSession.shared
        let url = URL(string: "http://www.perfectjumpshot.herokuapp.com")!
        let task = session.dataTask(with: url, completionHandler: { data, response, error in

            // Do something...
            print(data)
            print(response)
            print(error)
        })
        task.resume()
    }

}

