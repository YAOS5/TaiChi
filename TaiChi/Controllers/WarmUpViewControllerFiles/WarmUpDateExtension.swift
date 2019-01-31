//
//  WarmUpDateExtension.swift
//  TaiChi
//
//  Created by Peteski Shi on 31/1/19.
//  Copyright © 2019 Petech. All rights reserved.
//

import Foundation
import AFDateHelper

extension WarmUpViewController {
    
//    func getLastDateOnRecord() -> Date? {
//        let dayObject = realm.objects(Day.self).last
//        print("dayObject?.date", dayObject?.date)
//        if dayObject?.date == nil {
//            return nil
//        }
//        return Date(fromString: (dayObject?.date)!, format: .isoDate)
//    }
//
//
//    func isDifferentDay(currentDate: Date, dateOnRecord: Date?) -> Bool {
//        if dateOnRecord == nil {
//            return false
//        }
//        print("isDifferentDay result", !currentDate.compare(.isSameDay(as: dateOnRecord!)))
//        return !currentDate.compare(.isSameDay(as: dateOnRecord!))
//    }
    
    
    func updateDayDB(category: String, videoName: String, startTime: Time?, endTime: Time?) {
        
        let currentDate = Date()
        let dayObjects = realm.objects(Day.self)
        let dayObject = dayObjects.last
        if (dayObject == nil) || (dayObject?.date != currentDate.toString(format: .isoDate)) {
            // Then we need to create a new object
            print("New Day")
            let newDayObject = createNewDay(currentDate: currentDate)
            // Adding the new day object to the database
            try! realm.write {
                realm.add(newDayObject)
            }
            // Calculate the total watch time for yesterday
            if dayObjects.count > 1 {
                let yesterdayObject = dayObjects[dayObjects.count - 2]
                updateTotalWatchTimeInMinutes(dayObject: yesterdayObject)
            }
            updateVideoDB(dayObject: newDayObject, category: category, videoName: videoName, startTime: startTime, endTime: endTime)
        }
        else {
            // Then we can use the existing dateObject
            print("same day")
            updateVideoDB(dayObject: dayObject!, category: category, videoName: videoName, startTime: startTime, endTime: endTime)
        }
    }
    
    
    func createNewDay(currentDate: Date) -> Day {
        let newDayObject = Day()
        newDayObject.date = currentDate.toString(format: .isoDate)
        return newDayObject
    }
    
    
    func updateTotalWatchTimeInMinutes(dayObject: Day) {
        let videos = dayObject.videosWatched
        var totalTimeInSeconds = 0
        for i in 0 ..< videos.count {
            let playTimeList = videos[i].playTimeList
            for j in 0 ..< playTimeList.count {
                let startTime = playTimeList[j].startTime!
                let endTime = playTimeList[j].endTime!
                totalTimeInSeconds += calculatePlayDuration(startTime: startTime, endTime: endTime)
            }
        }
        dayObject.totalTimeInMinutes = Int(totalTimeInSeconds / 60)
    }
    
    
    func calculatePlayDuration(startTime: Time, endTime: Time) -> Int {
        var totalSeconds = 0
        // Making sure no one watched a video at midnight
        assert(startTime.hour <= endTime.hour)
        
        // Hour calculation
        let hourDiff = endTime.hour - startTime.hour
        let minutesDiff : Int
        let secondsDiff : Int
        
        // Minutes calculation
        if new(startInt: startTime.hour, endInt: endTime.hour) {
            minutesDiff = endTime.minutes
        }
        else {
            minutesDiff = endTime.minutes - startTime.minutes
        }
        // Seconds calculation
        if new(startInt: startTime.minutes, endInt: endTime.minutes) {
            secondsDiff = endTime.seconds
        }
        else {
            secondsDiff = endTime.seconds - startTime.seconds
        }
        
        totalSeconds = hourToSeconds(hour: hourDiff) + minutesToSeconds(minutes: minutesDiff) + secondsDiff
        return totalSeconds
    }
    
    
    func hourToSeconds(hour: Int) -> Int {
        return hour * 60
    }
    
    
    func minutesToSeconds(minutes: Int) -> Int {
        return minutes * 60
    }
    
    
    func new(startInt: Int, endInt: Int) -> Bool {
        return startInt > endInt
    }
    
}
