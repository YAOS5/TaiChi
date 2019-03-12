//
//  SelfPracticeDataExtension.swift
//  TaiChi
//
//  Created by Peteski Shi on 27/2/19.
//  Copyright © 2019 Petech. All rights reserved.
//


import Foundation
import AFDateHelper
import RealmSwift

extension SelfPracticeViewController {
    
    func storeTime(startTime: List<Int>?, endTime: List<Int>?) {
        updateDayDB(category: "SelfPractice", videoName: "SelfPractice", startTime: startTime, endTime: endTime)
    }
    
    
    func updateDayDB(category: String, videoName: String, startTime: List<Int>?, endTime: List<Int>?) {
        
        let currentDate = Date()
        let dayObjects = realm.objects(Day.self)
        let dayObject = dayObjects.last
        if (dayObject == nil) || (dayObject?.date != currentDate.toString(format: .isoDate)) {
            /* Check everyday besides today, to see if their totalTime is calculated and if the data has been passed to the cloud DB*/
            updateCloudDatabaseAndLocalWatchTime(dayObjects: dayObjects)
            
            /* Creating and adding the new day object to the database */
            let newDayObject = createNewDay(currentDate: currentDate)
            try! realm.write {
                realm.add(newDayObject)
            }
            updateVideoDB(dayObject: newDayObject, category: category, videoName: videoName, startTime: startTime, endTime: endTime)
        }
        else {
            /* Then we can use the existing dateObject */
            updateVideoDB(dayObject: dayObject!, category: category, videoName: videoName, startTime: startTime, endTime: endTime)
        }
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
    
    
    func createNewDay(currentDate: Date) -> Day {
        let newDayObject = Day()
        newDayObject.date = currentDate.toString(format: .isoDate)
        return newDayObject
    }
    
    
    func updateCloudDatabaseAndLocalWatchTime(dayObjects: Results<Day>) {
        for i in 0 ..< dayObjects.count {
            let dayObject = dayObjects[i]
            if dayObject.totalTimeInSeconds == 0 {
                let totalSeconds = calculateTotalWatchTimeInSeconds(dayObject: dayObject)
                try! realm.write {
                    dayObject.totalTimeInSeconds = totalSeconds
                }
                let watchTimeDictArray = constructStringDictFromDay(dayObject: dayObject)
                sendWatchDataToCloudDB(watchTimeDictArray: watchTimeDictArray)
                
            }
        }
        return
    }
    
    
    func calculateTotalWatchTimeInSeconds(dayObject: Day) -> Int {
        var totalTimeInSeconds = 0
        let videos = dayObject.videosWatched
        for i in 0 ..< videos.count {
            let playTimeList = videos[i].playTimeList
            for j in 0 ..< playTimeList.count {
                let startTime = playTimeList[j].startTime
                let endTime = playTimeList[j].endTime
                /* To make it more secure */
                if (startTime.count == 3) && (endTime.count == 3) {
                    totalTimeInSeconds += calculatePlayDuration(startTime: startTime, endTime: endTime)
                }
                else {
                    break
                }
            }
        }
        return totalTimeInSeconds
    }
    
    
    func calculatePlayDuration(startTime: List<Int>, endTime: List<Int>) -> Int {
        
        var totalSeconds = 0
        /* Making sure no one watched a video at midnight */
        let hour = 0
        let minutes = 1
        let seconds = 2
        assert(startTime[hour] <= endTime[hour])
        
        /* Hour calculation */
        var hourDiff = endTime[hour] - startTime[hour]
        var minutesDiff : Int
        var secondsDiff : Int
        
        print(hourDiff)
        /* Minutes calculation */
        if new(startInt: startTime[hour], endInt: endTime[hour]) {
            hourDiff -= 1
            minutesDiff = endTime[minutes] + 60 - startTime[minutes]
        }
        else {
            minutesDiff = endTime[minutes] - startTime[minutes]
        }
        
        /* Seconds calculation */
        if new(startInt: startTime[minutes], endInt: endTime[minutes]) {
            minutesDiff -= 1
            secondsDiff = endTime[seconds] + 60 - startTime[seconds]
        }
        else {
            secondsDiff = endTime[seconds] - startTime[seconds]
        }
        totalSeconds = hourToSeconds(hour: hourDiff) + minutesToSeconds(minutes: minutesDiff) + secondsDiff
        return totalSeconds
    }
    
    
    func hourToSeconds(hour: Int) -> Int {
        return hour * 60 * 60
    }
    
    
    func minutesToSeconds(minutes: Int) -> Int {
        return minutes * 60
    }
    
    
    func new(startInt: Int, endInt: Int) -> Bool {
        return startInt < endInt
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
