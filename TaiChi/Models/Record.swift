//
//  Record.swift
//  TaiChi
//
//  Created by Peteski Shi on 12/1/19.
//  Copyright © 2019 Petech. All rights reserved.
//

import Foundation

class Record {
    var date : NSDate
    var watchTime : timeval
    
    init(date: NSDate, watchTime: timeval) {
        self.date = date
        self.watchTime = watchTime
    }
}
