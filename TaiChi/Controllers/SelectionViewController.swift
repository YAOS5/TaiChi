//
//  SelectionViewController.swift
//  TaiChi
//
//  Created by Peteski Shi on 11/1/19.
//  Copyright © 2019 Petech. All rights reserved.
//

import UIKit

class SelectionViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    @IBAction func warmUpButton(_ sender: UIButton) {
        performSegue(withIdentifier: "Warm Up", sender: self)
    }
    
    @IBAction func taiChiButton(_ sender: UIButton) {
        performSegue(withIdentifier: "Tai Chi", sender: self)
    }
    

}
