//
//  Date.swift
//  TaiChi
//
//  Created by Peteski Shi on 16/1/19.
//  Copyright © 2019 Petech. All rights reserved.
//

import Foundation
import RealmSwift

class Day: Object {
    @objc dynamic var date : String = "2001-01-01"
    @objc dynamic var totalTimeInMinutes : Int = 0
    var videosWatched = List<Video>()
}
