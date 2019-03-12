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

func sendWatchDataToCloudDB(watchTimeDictArray: Array<Dictionary<String, String>>) {
    let dataURL = "http://58.221.127.78:9001/api/VideoInformation/VideoBrowseRecord"
    
    for i in 0 ..< watchTimeDictArray.count {
        print(watchTimeDictArray[i])
        AF.request(dataURL, method: .post, parameters: watchTimeDictArray[i], encoding: URLEncoding.httpBody,
                   headers: ["Content-Type": "application/x-www-form-urlencoded"]).responseJSON
            { response in
                
                print(response)
        }

    }
}
