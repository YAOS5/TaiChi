//
//  LoginVCPasswordExtension.swift
//  TaiChi
//
//  Created by Peteski Shi on 17/2/19.
//  Copyright © 2019 Petech. All rights reserved.
//

import UIKit
import RealmSwift
extension LoginViewController {
    
    
    func isFirstTimeLogin() -> Bool {
        return !(realm.objects(Login.self).first != nil)
    }
    
    
    func createLoginObjectFromTextFields(LoginId: String) -> Login {
        let loginObject = Login()
        loginObject.name = name.text!
        loginObject.ID = ID.text!
        loginObject.LoginId = LoginId
        
        return loginObject
    }
    
}
