//
//  SittingJSONExtension.swift
//  TaiChi
//
//  Created by Peteski Shi on 5/2/19.
//  Copyright © 2019 Petech. All rights reserved.
//

import Foundation
import SwiftyJSON
import RealmSwift
import AFDateHelper

extension SittingViewController {
    func fetchingLoginId() -> String{
        let loginObject = realm.objects(Login.self).first!
        return loginObject.LoginId
    }
    
    func constructJSONFromDay(dayObject: Day) -> Array<JSON>{
        var VideoJSONArray = Array<JSON>()
        let LoginId = fetchingLoginId()
        print(LoginId)
        let currentDate = dayObject.date
        print(currentDate)
        
        /* Extracting relevant information from video objects */
        let videoObjects = dayObject.videosWatched
        for i in 0 ..< videoObjects.count {
            let WatchTimeJSONArray = createJSONFromVideo(LoginId: LoginId, currentDate: currentDate, videoObject: videoObjects[i])
            print(WatchTimeJSONArray.count)
            for i in 0 ..< WatchTimeJSONArray.count {
                VideoJSONArray.append(WatchTimeJSONArray[i])
            }
        }
        return VideoJSONArray
    }
    
    
    func createJSONFromVideo(LoginId: String, currentDate: String, videoObject: Video) -> Array<JSON> {
        var WatchTimeJSONArray = Array<JSON>()
        
        let playTimeObjects = videoObject.playTimeList
        for i in 0 ..< playTimeObjects.count {
            var JSONDict = Dictionary<String,String>()
            let playTimeArray = convertTimeToString(currentDate: currentDate, playTime: playTimeObjects[i])
            let StartTime = playTimeArray[0]
            let EndTime = playTimeArray[1]
            
            JSONDict["LoginId"] = LoginId
            JSONDict["VideoCategory"] = videoObject.category!
            JSONDict["VideoName"] = videoObject.videoName!
            JSONDict["CurrentDate"] = currentDate
            JSONDict["StartTime"] = StartTime
            JSONDict["EndTime"] = EndTime
            
            WatchTimeJSONArray.append(JSON(JSONDict))
            print(JSON(JSONDict))
        }
        return WatchTimeJSONArray
    }
    
    
    func convertTimeToString(currentDate: String, playTime: PlayTime) -> Array<String> {
        var playTimeArray = Array<String>()
        let startStringArray = createStringArray(intList: playTime.startTime)
        var endStringArray = createStringArray(intList: playTime.endTime)
        
        /* In case that endStringArray is empty */
        if endStringArray.count == 0 {
            endStringArray = startStringArray
        }
        
        let StartTime = currentDate + " \(startStringArray[0]):\(startStringArray[1]):\(startStringArray[2])"
        let EndTime = currentDate + " \(endStringArray[0]):\(endStringArray[1]):\(endStringArray[2])"
        
        playTimeArray.append(StartTime)
        playTimeArray.append(EndTime)
        
        print(StartTime)
        print(EndTime)
        return playTimeArray
    }
    
    
    func createStringArray(intList: List<Int>) -> Array<String> {
        var stringArray = Array<String>()
        for i in 0 ..< intList.count {
            if intList[i] <= 9 {
                stringArray.append("0\(intList[i])")
            }
            else {
                stringArray.append("\(intList[i])")
            }
        }
        return stringArray
    }
    
}
