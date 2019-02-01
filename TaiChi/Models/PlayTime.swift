//
//  play time.swift
//  TaiChi
//
//  Created by Peteski Shi on 16/1/19.
//  Copyright © 2019 Petech. All rights reserved.
//

import Foundation
import RealmSwift


class PlayTime : Object {
    var startTime = List<Int>()
    var endTime = List<Int>()
    
    
    convenience init(startTime: List<Int>?, endTime: List<Int>?) {
        self.init()
        self.startTime = startTime ?? List<Int>()
        self.endTime = endTime ?? List<Int>()
    }
}
