//
//  WarmUpPlayVideoExtension.swift
//  TaiChi
//
//  Created by Peteski Shi on 30/1/19.
//  Copyright © 2019 Petech. All rights reserved.
//

import Foundation
import AVKit

extension WarmUpViewController {
    func playVideo(videoName: String, indexPath: IndexPath) {
        if let path = Bundle.main.path(forResource: videoName, ofType: "MP4") {
            let url = URL(fileURLWithPath: path)
            let video = AVPlayer(url: url)
            let videoPlayer = AVPlayerViewController()
            videoPlayer.player = video
            
            let fullLength = getVideoLength(url: url)
            print("fullLength", fullLength)
            
            present(videoPlayer, animated: true) {
                video.play()
            }
            
            /* Track the time played and enable loop play */
            manageTime(video: video, fullLength: fullLength, indexPath: indexPath)
        }
    }
    
    
    func manageTime(video: AVPlayer, fullLength: Double, indexPath: IndexPath){
        let interval = CMTime(seconds: 1, preferredTimescale: 1)
        var seconds : Double = 0.0
        video.addPeriodicTimeObserver(forInterval: interval, queue: nil) { (time) in
            seconds = Double(CMTimeGetSeconds(time))
            
            
            /* If it reaches the end of the video, then seek to the beginning */
            self.tryLoopPlay(video: video, fullLength: fullLength, seconds: seconds)
            
            /* Working with progress percentage */
            self.manageProgress(indexPath: indexPath, fullLength: fullLength, seconds: seconds)
            
            /* Feed the database the end time of the video*/
            let endTime = self.getTime()
            self.updateVideoDB(category: "WarmUp", videoName: "\(indexPath.row)", startTime: nil, endTime: endTime)
        }
    }
    
    func getVideoLength(url: URL) -> Double {
        let asset = AVAsset(url: url)
        let duration = asset.duration
        // rounding to one decimal place
        let fullLength: Double = Double(CMTimeGetSeconds(duration) * 10).rounded() / 10
        
        return fullLength
    }
    
    
    
    func tryLoopPlay(video: AVPlayer, fullLength: Double, seconds: Double) {
        if self.isLoopPlayEnabled {
            if (fullLength - seconds) < 0.1 {
                print("It is now at the end of the video")
                let beginning = CMTime(seconds: 0, preferredTimescale: 1)
                video.seek(to: beginning)
                /* If I don't pause, sometimes loop play doesn't work */
                video.pause()
                video.play()
            }
        }
    }
    
    
    func manageProgress (indexPath: IndexPath, fullLength: Double, seconds: Double) {
        var progress = Int((seconds / fullLength) * 100)
        // If most of the video has been played, then we just turn it to 100
        if progress > 95 {
            progress = 100
        }
        
        let cell = self.tableView.cellForRow(at: indexPath) as! VideoTableViewCell
        let videoName = cell.videoLabel.text!
        let validProgress = updateProgressDB(videoName: videoName, newProgress: progress)
        
        //TODO: the progress aint done
        updateProgressLabel(cell: cell, indexPath: indexPath, progress: validProgress)
    }
    
    
    func updateProgressLabel(cell: VideoTableViewCell, indexPath: IndexPath, progress: Int) {
        // Updating UI
        cell.progressLabel.text = "\(progress)%"
    }
    
    
    func updateProgressDB(videoName: String, newProgress: Int) -> Int {
        // Check if the video indexPath already exist
        let progressObject = realm.objects(Progress.self).filter("videoName == '\(videoName)'").first
        if progressObject == nil {
            // If it doesn't, add it to the DB
            print("It doesn't exist")
            addNewProgress(videoName: videoName, progress: newProgress)
            return newProgress
        }
        else {
            // If it does, check if it requires updating
            print("It does exist")
            let oldProgress = progressObject!.percentage
            if compareProgress(oldProgress: oldProgress, newProgress: newProgress) {
                try! realm.write {
                    progressObject?.percentage = newProgress
                    print("The new progress is \(newProgress)")
                }
                return newProgress
            }
            return oldProgress
        }
    }
    
    
    func compareProgress(oldProgress: Int, newProgress: Int) -> Bool{
        if newProgress > oldProgress {
            print("The new progress is higher")
            return true
        }
        print("The new progress is lower")
        return false
    }
    
    
    func addNewProgress(videoName : String, progress: Int) {
        print("adding new progress")
        let progressObject = Progress()
        progressObject.videoName = videoName
        progressObject.percentage = progress
        
        try! realm.write {
            realm.add(progressObject)
        }
    }
    
    
    func readProgress(videoName: String) -> String {
        let progressObject = realm.objects(Progress.self).filter("videoName == '\(videoName)'").first
        if progressObject == nil {
            return "0%"
        }
        let progress = progressObject!.percentage
        return "\(progress)%"
    }
}
