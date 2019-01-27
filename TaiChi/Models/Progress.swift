//
//  Progress.swift
//  TaiChi
//
//  Created by Peteski Shi on 27/1/19.
//  Copyright © 2019 Petech. All rights reserved.
//

import Foundation
import RealmSwift

class Progress: Object {
    @objc dynamic var videoName : String = ""
    @objc dynamic var percentage : Int = 0
    
    convenience init(videoName: String, percentage: Int) {
        self.init()
        self.videoName = videoName
        self.percentage = percentage
    }
    
}
