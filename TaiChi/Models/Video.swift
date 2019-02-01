//
//  video.swift
//  TaiChi
//
//  Created by Peteski Shi on 16/1/19.
//  Copyright © 2019 Petech. All rights reserved.
//

import Foundation
import RealmSwift


class Video : Object {
    @objc dynamic var Category : String?
    @objc dynamic var videoName : String?
    var playTimeList = List<PlayTime>()  // In case exercises are done multiple times a day
}
