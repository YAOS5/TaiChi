//
//  standingNetworkingExtension.swift
//  TaiChi
//
//  Created by Peteski Shi on 6/3/19.
//  Copyright © 2019 Petech. All rights reserved.
//

import Foundation
import Alamofire


extension StandingViewController {
    
    func sendDayInfo(dayObject: Day) {
        let dayJSON = createJSONObject(dayInfoArray: getDayInfo(dayObject: dayObject))
    }
}
