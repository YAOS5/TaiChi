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
    let testArray : [String] = ["square.jpg", "square.jpg", "square.jpg", "square.jpg", "square.jpg", "square.jpg", "square.jpg", "square.jpg", "square.jpg", "square.jpg", "square.jpg", "square.jpg"]

    
    
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
        return cell
    }
    
    // Adjusting the height of the rows, might change it later
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 140
    }
    
}
