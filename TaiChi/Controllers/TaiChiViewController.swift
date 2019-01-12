//
//  TaiChiViewController.swift
//  TaiChi
//
//  Created by Peteski Shi on 11/1/19.
//  Copyright © 2019 Petech. All rights reserved.
//

import UIKit

class TaiChiViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    let testArray : [String] = ["square.jpg", "square.jpg", "square.jpg", "square.jpg", "square.jpg", "square.jpg"]
    @IBOutlet weak var tableView: UITableView!
    
    
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
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 140
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print(indexPath.row)
    }
    

}
