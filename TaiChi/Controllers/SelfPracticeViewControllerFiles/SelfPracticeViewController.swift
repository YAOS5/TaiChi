//
//  SelfPracticeViewController.swift
//  TaiChi
//
//  Created by Peteski Shi on 26/2/19.
//  Copyright © 2019 Petech. All rights reserved.
//

import UIKit
import AFDateHelper
import RealmSwift

class SelfPracticeViewController: UIViewController {

    @IBOutlet weak var startButton: UIButton!
    @IBOutlet weak var endButton: UIButton!
    let realm = try! Realm()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        startButton.getShadow(button: startButton)
        endButton.getShadow(button: endButton)
        disableButton(button: endButton)
    }
    
    
    @IBAction func startButton(_ sender: UIButton) {
        disableButton(button: startButton)
        enableButton(button: endButton)
        let startTime = getTime()
        storeTime(startTime: startTime, endTime: nil)
        
        
    }
    @IBAction func endButton(_ sender: UIButton) {
        disableButton(button: endButton)
        enableButton(button: startButton)
        let endTime = getTime()
        storeTime(startTime: nil, endTime: endTime)
    }
    
    
    func enableButton(button: UIButton) {
        button.alpha = 1
        button.isUserInteractionEnabled = true
    }
    
    
    func disableButton(button: UIButton) {
        button.alpha = 0.5
        button.isUserInteractionEnabled = false
    }
    
    
    func getTime() -> List<Int> {
        /* Getting the current time and returning the values in a list for realm */
        let date = Date()
        let time = List<Int>()
        
        let calendar = Calendar.current
        let hour = calendar.component(.hour, from: date)
        let minutes = calendar.component(.minute, from: date)
        let seconds = calendar.component(.second, from: date)
        
        time.append(hour)
        time.append(minutes)
        time.append(seconds)
        return time
    }
    
}


