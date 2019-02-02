//
//  WarmUpDateExtension.swift
//  TaiChi
//
//  Created by Peteski Shi on 31/1/19.
//  Copyright © 2019 Petech. All rights reserved.
//

import Foundation
import AFDateHelper
import RealmSwift

extension TaiChiViewController {
    
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

    
    
    func updateDayDB(category: String, videoName: String, startTime: List<Int>?, endTime: List<Int>?) {
        
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
    
    
    func updateTotalWatchTimeInMinutes(dayObjects: Results<Day>) {
        
        var totalTimeInSeconds = 0
        for k in 0 ..< dayObjects.count - 1 {
            let dayObject = dayObjects[k]
            if dayObject.totalTimeInMinutes == 0 {
                // Then it means that the totaltime calculation is never done
                let videos = dayObject.videosWatched
                for i in 0 ..< videos.count {
                    let playTimeList = videos[i].playTimeList
                    for j in 0 ..< playTimeList.count {
                        let startTime = playTimeList[j].startTime
                        let endTime = playTimeList[j].endTime
                        // To make it more secure
                        if (startTime.count == 3) && (endTime.count == 3) {
                            totalTimeInSeconds += calculatePlayDuration(startTime: startTime, endTime: endTime)
                        }
                        else {
                            break
                        }
                    }
                }
                try! realm.write {
                    dayObject.totalTimeInMinutes = Int(totalTimeInSeconds / 60)
                }
            }
        }
    }
    
    
    func calculatePlayDuration(startTime: List<Int>, endTime: List<Int>) -> Int {
        
        var totalSeconds = 0
        // Making sure no one watched a video at midnight
        let hour = 0
        let minutes = 1
        let seconds = 2
        assert(startTime[hour] <= endTime[hour])
        
        // Hour calculation
        var hourDiff = endTime[hour] - startTime[hour]
        var minutesDiff : Int
        var secondsDiff : Int
        
        // Minutes calculation
        if new(startInt: startTime[hour], endInt: endTime[hour]) {
            hourDiff -= 1
            minutesDiff = endTime[minutes] + 60 - startTime[minutes]
        }
        else {
            minutesDiff = endTime[minutes] - startTime[minutes]
        }
        // Seconds calculation
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
        return hour * 60
    }
    
    
    func minutesToSeconds(minutes: Int) -> Int {
        return minutes * 60
    }
    
    
    func new(startInt: Int, endInt: Int) -> Bool {
        return startInt < endInt
    }
    
}
