//
//  SelectionViewController.swift
//  TaiChi
//
//  Created by Peteski Shi on 11/1/19.
//  Copyright © 2019 Petech. All rights reserved.
//

import UIKit

class SelectionViewController: UIViewController {

    @IBOutlet weak var warmUpButton: UIButton!
    @IBOutlet weak var taiChiButton: UIButton!
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        warmUpButton.getShadow(button: warmUpButton)
        taiChiButton.getShadow(button: taiChiButton)
    }
    
    
    /* Controlling the appearence of the navigational controller */
    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.isNavigationBarHidden = true
    }
    override func viewWillDisappear(_ animated: Bool) {
        self.navigationController?.isNavigationBarHidden = false
    }
    
    
    @IBAction func warmUpButton(_ sender: UIButton) {
        performSegue(withIdentifier: "Warm Up", sender: self)
    }
    
    
    @IBAction func taiChiButton(_ sender: UIButton) {
        performSegue(withIdentifier: "Tai Chi", sender: self)
    }
    
    

}
