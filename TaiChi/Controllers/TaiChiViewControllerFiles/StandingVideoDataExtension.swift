//
//  WarmUpDataExtension.swift
//  TaiChi
//
//  Created by Peteski Shi on 30/1/19.
//  Copyright © 2019 Petech. All rights reserved.
//

import Foundation
import RealmSwift

extension StandingViewController {
    
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
        let videoObjects = dayObject.videosWatched
        if checkExistance(videoName: videoName, videoObjects: videoObjects) == -1 {
            let newVideoObject = createVideoObject(category: category, videoName: videoName)
            addVideoToDay(dayObject: dayObject, videoObject: newVideoObject)
            updateTimeDB(videoObject: newVideoObject, startTime: startTime, endTime: endTime)
        }
        else {
            let index = checkExistance(videoName: videoName, videoObjects: videoObjects)
            updateTimeDB(videoObject: videoObjects[index], startTime: startTime, endTime: endTime)
        }
    }
    
    
    func checkExistance(videoName: String, videoObjects: List<Video>) -> Int {
        for i in 0 ..< videoObjects.count {
            if videoName == videoObjects[i].videoName! {
                return i
            }
        }
        return -1
    }
    
    
    func addVideoToDay(dayObject: Day, videoObject: Video) {
        try! realm.write {
            dayObject.videosWatched.append(videoObject)
        }
    }
    
    
    func createVideoObject(category: String, videoName: String) -> Video {
        let videoObject = Video()
        videoObject.category = category
        videoObject.videoName = videoName
        
        return videoObject
    }
    
    
    func updateTimeDB(videoObject: Video, startTime: List<Int>?, endTime: List<Int>?) {
        if shouldStartNewEntry(startTime: startTime) {
            /* Then it means that the previous start-end pair is already complete */
            let playTime = PlayTime(startTime: startTime, endTime: endTime)
            try! realm.write {
                videoObject.playTimeList.append(playTime)
            }
        }
        else {
            /* Then it means the previous pair is not complete yet */
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
