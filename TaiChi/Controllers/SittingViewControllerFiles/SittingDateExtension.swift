//
//  SittingDateExtension.swift
//  TaiChi
//
//  Created by Peteski Shi on 31/1/19.
//  Copyright © 2019 Petech. All rights reserved.
//

import Foundation
import AFDateHelper
import RealmSwift

extension SittingViewController {
    
    func updateDayDB(category: String, videoName: String, startTime: List<Int>?, endTime: List<Int>?) {
        
        let currentDate = Date()
        let dayObjects = realm.objects(Day.self)
        let dayObject = dayObjects.last
        if (dayObject == nil) || (dayObject?.date != currentDate.toString(format: .isoDate)) {
            /* Creating and adding the new day object to the database */
            let newDayObject = createNewDay(currentDate: currentDate)
            try! realm.write {
                realm.add(newDayObject)
            }
            updateVideoDB(dayObject: newDayObject, category: category, videoName: videoName, startTime: startTime, endTime: endTime)
            /* Check everyday besides today, to see if their totalTime is calculated */
            updateTotalWatchTimeInMinutes(dayObjects: dayObjects)
        }
        else {
            /* Then we can use the existing dateObject */
            updateVideoDB(dayObject: dayObject!, category: category, videoName: videoName, startTime: startTime, endTime: endTime)
        }
    }
    
    
    func createNewDay(currentDate: Date) -> Day {
        let newDayObject = Day()
        newDayObject.date = currentDate.toString(format: .isoDate)
        return newDayObject
    }
    
    
    func updateTotalWatchTimeInMinutes(dayObjects: Results<Day>) {
        if dayObjects.count <= 1 {
            return
        }
        else {
            for i in 0 ..< dayObjects.count - 1 {
                let dayObject = dayObjects[i]
                if dayObject.totalTimeInMinutes == 0 {
                    let totalMinutes = calculateTotalWatchTimeInMinutes(dayObject: dayObject)
                    try! realm.write {
                        dayObject.totalTimeInMinutes = totalMinutes
                    }
                }
            }
        }
    }
    
    
    func calculateTotalWatchTimeInMinutes(dayObject: Day) -> Int {
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
        return Int(totalTimeInSeconds / 60)
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
    
}

