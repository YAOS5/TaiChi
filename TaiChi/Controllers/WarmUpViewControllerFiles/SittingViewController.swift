//
//  SittingViewController.swift
//  TaiChi
//
//  Created by Peteski Shi on 11/1/19.
//  Copyright © 2019 Petech. All rights reserved.
//

import UIKit
import AVKit
import RealmSwift
import UICircularProgressRing

class SittingViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {

    let realm = try! Realm()
    
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
    
    
    let testArray : [String] = ["square.jpg", "square.jpg", "square.jpg", "square.jpg", "square.jpg", "square.jpg", "square.jpg", "square.jpg", "square.jpg", "square.jpg"]
    let titleArray : [String] = ["完整演示", "概述", "第一式 升降式", "第二式 云手", "第三式 开合式", "第四式 野马分鬃", "第五式 白鹤亮翅", "第六式 搂膝拗步", "第七式 倒卷肱", "第八式 收势"]
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.navigationBar.topItem!.title = "返回"
        print(Realm.Configuration.defaultConfiguration.fileURL!)
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
        
        // loading progress
        let progress : Int = readProgress(videoCode: cell.videoLabel.text!)
        cell.progressRing.startProgress(to: CGFloat(progress), duration: 0)
        return cell
    }
    
    // Adjusting the height of the rows, might change it later
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 120
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        playVideo(videoName: "s\(indexPath.row)", indexPath: indexPath)
        
        /* feed the database the start time of the video */
        let startTime = getTime()
        updateDayDB(category: "Sitting", videoName: "\(titleArray[indexPath.row])", startTime: startTime, endTime: nil)
        self.tableView.deselectRow(at: indexPath, animated: true)
    }
    
    
}
