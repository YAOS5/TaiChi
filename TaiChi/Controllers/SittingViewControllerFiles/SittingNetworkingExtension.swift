//
//  SittingNetworkingExtension.swift
//  TaiChi
//
//  Created by Peteski Shi on 6/3/19.
//  Copyright © 2019 Petech. All rights reserved.
//

import Foundation
import SwiftyJSON
import Alamofire

func sendWatchDataToCloudDB(watchTimeJSONArray: Array<JSON>) {
    let dataURL = "http://58.221.127.78:9001/api/VideoInformation/VideoBrowseRecord"
    
    for i in 0 ..< watchTimeJSONArray.count {
        //
    }
}
