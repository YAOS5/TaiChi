//
//  TaiChiViewController.swift
//  TaiChi
//
//  Created by Peteski Shi on 11/1/19.
//  Copyright © 2019 Petech. All rights reserved.
//

import UIKit
import AVKit

class TaiChiViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    @IBOutlet weak var tableView: UITableView!
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
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 140
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        playVideo(videoName: "\(indexPath.row)")
        self.tableView.deselectRow(at: indexPath, animated: true)
    }
    
    func playVideo(videoName: String) {
        if let path = Bundle.main.path(forResource: videoName, ofType: "MP4") {
            let video = AVPlayer(url: URL(fileURLWithPath: path))
            let videoPlayer = AVPlayerViewController()
            videoPlayer.player = video
            
            //prot code
            let interval = CMTime(seconds: 1, preferredTimescale: 1)
            video.addPeriodicTimeObserver(forInterval: interval, queue: nil) { (time) in
                let seconds = CMTimeGetSeconds(time)
                print(Int(seconds))
            }
            
            present(videoPlayer, animated: true) {
                video.play()
            }
            
        }
    }
    

}
