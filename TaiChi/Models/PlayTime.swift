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
    @objc dynamic var startTime : Time?
    @objc dynamic var endTime : Time?
}
