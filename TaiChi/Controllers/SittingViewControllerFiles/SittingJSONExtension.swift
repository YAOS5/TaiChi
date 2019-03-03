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

extension SittingViewController {
    
    
    func createJSONObject(dayInfoArray: Array<Any>) -> JSON {
        
        let json = JSON(arrayLiteral: dayInfoArray)
        print(json)
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
        return videoInfoArray
    }
    
    
    func getPlayTimeInfo(playTime: PlayTime) -> Dictionary<String, Array<Int>> {
        /* Returns an dictionary which stores string keys and List-of-Int values */
        var playTimeDict = [String: Array<Int>]()

        let startTime = Array(playTime.startTime)
        let endTime = Array(playTime.endTime)
        playTimeDict["startTime"] = startTime
        playTimeDict["endTime"] = endTime
        
        return playTimeDict
    }
}
