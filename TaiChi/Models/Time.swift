//
//  Time.swift
//  TaiChi
//
//  Created by Peteski Shi on 29/1/19.
//  Copyright © 2019 Petech. All rights reserved.
//

import Foundation
import RealmSwift

class Time : Object {
    @objc dynamic var hour : Int = 0
    @objc dynamic var minutes : Int = 0
    @objc dynamic var seconds : Int = 0
    
    convenience init(hour: Int, minutes: Int, seconds: Int) {
        self.init()
        self.hour = hour
        self.minutes = minutes
        self.seconds = seconds
    }
}
