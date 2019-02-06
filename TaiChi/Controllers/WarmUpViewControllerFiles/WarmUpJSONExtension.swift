//
//  WarmUpJSONExtension.swift
//  TaiChi
//
//  Created by Peteski Shi on 5/2/19.
//  Copyright © 2019 Petech. All rights reserved.
//

import Foundation
import SwiftyJSON
import RealmSwift

extension WarmUpViewController {
    
    
    func createJSONObject(dayInfoArray: Array<Any>) -> JSON {
        
        let json = JSON(arrayLiteral: dayInfoArray)
        return json
    }
    
    
    func getDayInfo(dayObject: Day) -> Array<Any> {
        var dayInfoArray = [Any]()
        
        let date = dayObject.date
        let totalTimeInMinutes = dayObject.totalTimeInMinutes
        dayInfoArray.append(date)
        dayInfoArray.append(totalTimeInMinutes)
        
        var videosInfoArray = [Array<Any>]()
        let videoObjects = dayObject.videosWatched
        for i in 0 ..< videoObjects.count {
            videosInfoArray.append(getVideoInfo(videoObject: videoObjects[i]))
        }
        
        dayInfoArray.append(videosInfoArray)
//        print("dayInfoArray", dayInfoArray)
        return dayInfoArray
    }
    
    
    func getVideoInfo(videoObject: Video) -> Array<Any> {
        var videoInfoArray = [Any]()
        
        let category = videoObject.category
        let videoName = videoObject.videoName
        videoInfoArray.append(category!)
        videoInfoArray.append(videoName!)
        
        var playTimeArray = [Dictionary<String, Array<Int>>]()
        let playTimeObjects = videoObject.playTimeList
        
        for i in 0 ..< playTimeObjects.count {
            let playTimeDict = getPlayTimeInfo(playTime: playTimeObjects[i])
            playTimeArray.append(playTimeDict)
        }
        
        videoInfoArray.append(contentsOf: playTimeArray)
//        print("videoInfoArray", videoInfoArray)
        return videoInfoArray
    }
    
    
    func getPlayTimeInfo(playTime: PlayTime) -> Dictionary<String, Array<Int>> {
        /* Returns an dictionary which stores string keys and List-of-Int values */
        
        var playTimeDict = [String: Array<Int>]()

        let startTime = Array(playTime.startTime)
        let endTime = Array(playTime.endTime)
        playTimeDict["startTime"] = startTime
        playTimeDict["endTime"] = endTime
        
//        print("playTimeDict", playTimeDict)
        return playTimeDict
//        let startHour = playTime.startTime[0]
//        let startMinute = playTime.startTime[1]
//        let startSecond = playTime.startTime[2]
//        let endHour = playTime.endTime[0]
//        let endMinute = playTime.endTime[1]
//        let endSecond = playTime.endTime[2]
    }
}
