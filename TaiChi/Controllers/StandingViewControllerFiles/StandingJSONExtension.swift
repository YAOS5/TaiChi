//
//  StandingJSONExtension.swift
//  TaiChi
//
//  Created by Peteski Shi on 5/2/19.
//  Copyright © 2019 Petech. All rights reserved.
//

import Foundation
import SwiftyJSON
import RealmSwift
import AFDateHelper

extension StandingViewController {
    func fetchingLoginId() -> String{
        let loginObject = realm.objects(Login.self).first!
        return loginObject.LoginId
    }
    
    func constructStringDictFromDay(dayObject: Day) -> Array<Dictionary<String, String>>{
        var watchTimeDictArray = Array<Dictionary<String, String>>()
        let LoginId = fetchingLoginId()
        let currentDate = dayObject.date
        
        /* Extracting relevant information from video objects */
        let videoObjects = dayObject.videosWatched
        for i in 0 ..< videoObjects.count {
            let WatchTimeDictArray = createStringDictFromVideo(LoginId: LoginId, currentDate: currentDate, videoObject: videoObjects[i])
            for i in 0 ..< WatchTimeDictArray.count {
                watchTimeDictArray.append(WatchTimeDictArray[i])
            }
        }
        return watchTimeDictArray
    }
    
    
    func createStringDictFromVideo(LoginId: String, currentDate: String, videoObject: Video) -> Array<Dictionary<String, String>>{
        var WatchTimeStringArray =  Array<Dictionary<String, String>>()
        
        let playTimeObjects = videoObject.playTimeList
        for i in 0 ..< playTimeObjects.count {
            var StringDict = Dictionary<String,String>()
            let playTimeArray = convertTimeToString(currentDate: currentDate, playTime: playTimeObjects[i])
            let StartTime = playTimeArray[0]
            let EndTime = playTimeArray[1]
            
            StringDict["LoginId"] = LoginId
            StringDict["VideoCategory"] = videoObject.category!
            StringDict["VideoName"] = videoObject.videoName!
            StringDict["CurrentData"] = currentDate
            StringDict["StartTime"] = StartTime
            StringDict["EndTime"] = EndTime
            
            WatchTimeStringArray.append(StringDict)
        }
        return WatchTimeStringArray
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

