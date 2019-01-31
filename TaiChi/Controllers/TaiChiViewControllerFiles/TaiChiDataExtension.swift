//
//  WarmUpDataExtension.swift
//  TaiChi
//
//  Created by Peteski Shi on 30/1/19.
//  Copyright © 2019 Petech. All rights reserved.
//

import Foundation

extension TaiChiViewController {
    
    func getTime() -> Time {
        let date = Date()
        let calendar = Calendar.current
        let hour = calendar.component(.hour, from: date)
        let minutes = calendar.component(.minute, from: date)
        let seconds = calendar.component(.second, from: date)
        
        let time = Time(hour: hour, minutes: minutes, seconds: seconds)
        return time
    }
    
    func updateVideoDB(category: String, videoName: String, startTime: Time?, endTime: Time?) {
        let videoObject = realm.objects(Video.self).filter("videoName == '\(videoName)'").first
        if videoObject == nil {
            print("Video object doesn't exist")
            let newVideoObject = addNewVideo(category: category, videoName: videoName)
            updateTimeDB(videoObject: newVideoObject, startTime: startTime, endTime: endTime)
            
        }
        else {
            print("Video object exists")
            updateTimeDB(videoObject: videoObject!, startTime: startTime, endTime: endTime)
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
    
    func updateTimeDB(videoObject: Video, startTime: Time?, endTime: Time?) {
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
                videoObject.playTimeList.last!.endTime = endTime!
            }
            
        }
        
        
    }
    
    
    func shouldStartNewEntry(startTime: Time?) -> Bool {
        if startTime == nil {
            return false
        }
        return true
    }
}
