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
    @objc dynamic var videoCode : String = ""
    @objc dynamic var percentage : Int = 0
    
    convenience init(videoCode: String, percentage: Int) {
        self.init()
        self.videoCode = videoCode
        self.percentage = percentage
    }
    
}
