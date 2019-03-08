//
//  ViewController.swift
//  TaiChi
//
//  Created by Peteski Shi on 11/1/19.
//  Copyright © 2019 Petech. All rights reserved.
//

import UIKit
import RealmSwift

class LoginViewController: UIViewController, UITextFieldDelegate {
    @IBOutlet weak var loginButton: UIButton!
    @IBOutlet weak var errorLabel: UILabel!
    
    
    let realm = try! Realm()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        loginButton.getShadow(button: loginButton)
        initErrorLabel()
        
        self.hideKeyboard()
        self.name.delegate = self
        self.ID.delegate = self
        
        
        /* Check if the user is logging in for the first time */
        if !isFirstTimeLogin() {
            /* Autofill the two text fields if the user has logged in before */
            let loginObject = realm.objects(Login.self).first!
            name.text = loginObject.name
            ID.text = loginObject.ID
        }
    }
    
    
    /* Controlling the appearence of the navigational controller */
//    override func viewWillAppear(_ animated: Bool) {
//        self.navigationController?.isNavigationBarHidden = true
//    }
//    override func viewWillDisappear(_ animated: Bool) {
//        self.navigationController?.isNavigationBarHidden = false
//    }
//    
    
    /* Configuring the login text fields */
    @IBOutlet weak var name: UITextField! {
        didSet {
            name.tintColor = UIColor.lightGray
            name.setIcon(UIImage(imageLiteralResourceName: "UserAvatar"))
        }
    }
    
    @IBOutlet weak var ID: UITextField! {
        didSet {
            ID.tintColor = UIColor.lightGray
            ID.setIcon(UIImage(imageLiteralResourceName: "Lock"))
        }
    }
    
    
    @IBAction func loginButton(_ sender: UIButton) {
        checkCredentialsWithCloudDB(Name: name.text, ID: ID.text)
    }
    
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        name.resignFirstResponder()
        ID.resignFirstResponder()
        return true
    }
    
    
    func initErrorLabel() {
        errorLabel.layer.masksToBounds = true
        errorLabel.layer.cornerRadius = 10
        errorLabel.isHidden = true
    }

}

