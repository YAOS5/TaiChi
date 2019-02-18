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
    
    
    func checkCredentialsWithCloudDB() -> Bool {
        //TODO: Modify this ethod after networking bit is done
        return true
    }
    
    
    func createLoginObjectFromTextFields() -> Login {
        let loginObject = Login()
        loginObject.Name = name.text!
        loginObject.ID = ID.text!
        
        return loginObject
    }
    
}
