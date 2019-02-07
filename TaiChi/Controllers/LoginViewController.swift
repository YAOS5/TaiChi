//
//  ViewController.swift
//  TaiChi
//
//  Created by Peteski Shi on 11/1/19.
//  Copyright © 2019 Petech. All rights reserved.
//

import UIKit

class LoginViewController: UIViewController, UITextFieldDelegate {
    @IBOutlet weak var loginButton: UIButton!

    
    override func viewDidLoad() {
        super.viewDidLoad()
        loginButton.getShadow(button: loginButton)
        self.hideKeyboard()
        self.userName.delegate = self
        self.password.delegate = self
    }
    
    
    /* Controlling the appearence of the navigational controller */
    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.isNavigationBarHidden = true
    }
    override func viewWillDisappear(_ animated: Bool) {
        self.navigationController?.isNavigationBarHidden = false
    }
    
    
    /* Configuring the login text fields */
    @IBOutlet weak var userName: UITextField! {
        didSet {
            userName.tintColor = UIColor.lightGray
            userName.setIcon(UIImage(imageLiteralResourceName: "UserAvatar"))
        }
    }
    @IBOutlet weak var password: UITextField! {
        didSet {
            password.tintColor = UIColor.lightGray
            password.setIcon(UIImage(imageLiteralResourceName: "Lock"))
        }
    }
    
    
    
    @IBAction func loginButton(_ sender: UIButton) {
        performSegue(withIdentifier: "toSelection", sender: self)
    }
    
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        userName.resignFirstResponder()
        password.resignFirstResponder()
        return true
    }

}

