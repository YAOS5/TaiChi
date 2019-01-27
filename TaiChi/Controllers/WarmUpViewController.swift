//
//  WarmUpViewController.swift
//  TaiChi
//
//  Created by Peteski Shi on 11/1/19.
//  Copyright © 2019 Petech. All rights reserved.
//

import UIKit
import AVKit

class WarmUpViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {

    @IBOutlet weak var tableView: UITableView!
    
    var isLoopPlayEnabled = false
    @IBAction func loopSwitch(_ sender: UISwitch) {
        if (sender.isOn) {
            isLoopPlayEnabled = true
        }
        else {
            isLoopPlayEnabled = false
        }
    }
    
    
    let testArray : [String] = ["square.jpg", "square.jpg", "square.jpg"]
    let titleArray : [String] = ["rehab video 1", "rehab video 2", "rehab video 3"]
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let videoNibCell = UINib(nibName: "VideoTableViewCell", bundle: nil)
        tableView.register(videoNibCell, forCellReuseIdentifier: "VideoTableViewCell")
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return testArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "VideoTableViewCell", for: indexPath) as! VideoTableViewCell
        cell.videoImageView.image = UIImage(named: testArray[indexPath.row])
        cell.videoLabel.text = titleArray[indexPath.row]
        return cell
    }
    
    // Adjusting the height of the rows, might change it later
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 140
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        playVideo(videoName: "\(indexPath.row)")
        self.tableView.deselectRow(at: indexPath, animated: true)
    }
    
    
    func playVideo(videoName: String) {
        if let path = Bundle.main.path(forResource: videoName, ofType: "MP4") {
            let url = URL(fileURLWithPath: path)
            let video = AVPlayer(url: url)
            let videoPlayer = AVPlayerViewController()
            videoPlayer.player = video
            
            // Trying to implement looping
            let fullLength = getVideoLength(url: url)
            print("fullLength", fullLength)
            
            /* Calling this function to track the time played and enable loop play */
            manageTime(video: video, fullLength: fullLength)
            
            present(videoPlayer, animated: true) {
                video.play()
            }
        }
    }
    
    
    func getVideoLength(url: URL) -> Double {
        let asset = AVAsset(url: url)
        let duration = asset.duration
        // rounding to one decimal place
        let fullLength: Double = Double(CMTimeGetSeconds(duration) * 10).rounded() / 10
        
        return fullLength
    }
    
    
    func manageTime(video: AVPlayer, fullLength: Double){
        let interval = CMTime(seconds: 1, preferredTimescale: 1)
        var seconds : Double = 0.0
        video.addPeriodicTimeObserver(forInterval: interval, queue: nil) { (time) in
            seconds = Double(CMTimeGetSeconds(time))
            print(seconds)
            
            /* If it reaches the end of the video, then seek to the beginning */
            if self.isLoopPlayEnabled {
                if (fullLength - seconds) < 0.1 {
                    print("It is now at the end of the video")
                    let beginning = CMTime(seconds: 0, preferredTimescale: 1)
                    video.seek(to: beginning)
                    seconds = 0.00
                    
                    /* If I don't pause, sometimes loop play doesn't work */
                    video.pause()
                    video.play()
                }
            }
        }
    }
}
