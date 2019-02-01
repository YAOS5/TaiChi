//
//  WarmUpDataExtension.swift
//  TaiChi
//
//  Created by Peteski Shi on 30/1/19.
//  Copyright © 2019 Petech. All rights reserved.
//

import Foundation
import RealmSwift

extension TaiChiViewController {
    
    func getTime() -> List<Int> {
        let date = Date()
        let time = List<Int>()
        
        let calendar = Calendar.current
        let hour = calendar.component(.hour, from: date)
        let minutes = calendar.component(.minute, from: date)
        let seconds = calendar.component(.second, from: date)
        
        time.append(hour)
        time.append(minutes)
        time.append(seconds)
        return time
    }
    
    func updateVideoDB(dayObject: Day, category: String, videoName: String, startTime: List<Int>?, endTime: List<Int>?) {
        let videoObject = realm.objects(Video.self).filter("videoName == '\(videoName)'").first
        if videoObject == nil {
            print("Video object doesn't exist")
            let newVideoObject = addNewVideo(category: category, videoName: videoName)
            updateTimeDB(videoObject: newVideoObject, startTime: startTime, endTime: endTime)
            addVideoToDay(dayObject: dayObject, videoObject: newVideoObject)
            
        }
        else {
            print("Video object exists")
            updateTimeDB(videoObject: videoObject!, startTime: startTime, endTime: endTime)
        }
    }
    
    func addVideoToDay(dayObject: Day, videoObject: Video) {
        try! realm.write {
            dayObject.videosWatched.append(videoObject)
        }
    }
    
    
    func addNewVideo(category: String, videoName: String) -> Video {
        print("Adding new video object")
        let videoObject = Video()
        videoObject.Category = category
        videoObject.videoName = videoName
        
        try! realm.write {
            realm.add(videoObject)
        }
        return videoObject
    }
    
    
    func updateTimeDB(videoObject: Video, startTime: List<Int>?, endTime: List<Int>?) {
        print("Updating timeDB")
        if shouldStartNewEntry(startTime: startTime) {
            // Then it means that the previous start-end pair is already complete
            let playTime = PlayTime(startTime: startTime, endTime: endTime)
            try! realm.write {
                videoObject.playTimeList.append(playTime)
            }
        }
        else {
            // Then it means the previous pair is not complete yet
            try! realm.write {
                if videoObject.playTimeList.last!.endTime.count == 0 {
                    videoObject.playTimeList.last!.endTime.append(objectsIn: endTime!)
                }
                else {
                    videoObject.playTimeList.last!.endTime[0] = endTime![0]
                    videoObject.playTimeList.last!.endTime[1] = endTime![1]
                    videoObject.playTimeList.last!.endTime[2] = endTime![2]
                }
            }
            
        }
        
        
    }
    
    
    func shouldStartNewEntry(startTime: List<Int>?) -> Bool {
        if startTime == nil {
            return false
        }
        return true
    }
}
