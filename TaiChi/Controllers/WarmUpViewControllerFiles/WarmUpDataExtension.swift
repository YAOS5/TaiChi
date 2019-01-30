//
//  WarmUpDataExtension.swift
//  TaiChi
//
//  Created by Peteski Shi on 30/1/19.
//  Copyright © 2019 Petech. All rights reserved.
//

import Foundation

extension WarmUpViewController {
    func getTime() -> Array<Int> {
        let date = Date()
        let calendar = Calendar.current
        let hour = calendar.component(.hour, from: date)
        let minutes = calendar.component(.minute, from: date)
        let seconds = calendar.component(.second, from: date)
        print(hour, minutes, seconds)
        return [hour, minutes, seconds]
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
        return videoObject
    }
    
    func updateTimeDB(videoObject: Video, startTime: Time?, endTime: Time?) {
        print("Updating timeDB")
        
        
        
    }
    
    func shouldStartNewEntry() {
        
    }
}
