//
//  LoginVCNetworkingExtension.swift
//  TaiChi
//
//  Created by Peteski Shi on 6/3/19.
//  Copyright © 2019 Petech. All rights reserved.
//

import Foundation
import Alamofire
import SwiftyJSON

extension LoginViewController {
    func checkCredentialsWithCloudDB(Name: String, ID: String) {
        /* If nothing is returned, display error label and terminate the function */
        if (Name == "") || (ID == "") {
            displayErrorLabel(text: "姓名或病案号错误")
            return
        }
        
        var Parameters = Dictionary<String,String>()
        Parameters["UserName"] = Name
        Parameters["PassWord"] = ID
        
        let loginURL = "http://58.221.127.78:9001/api/Login/LoginOn"
        AF.request(loginURL, method: .post, parameters: Parameters, encoding: URLEncoding.httpBody,
                   headers: ["Content-Type": "application/x-www-form-urlencoded"]).responseJSON
            { response in
                if response.error != nil {
                    self.displayErrorLabel(text: "请检查网络连接")
                }
                else {
                    /* Extracting the JSON */
                    let responseJSON : JSON = JSON(response.result.value!)
                    if responseJSON["LoginId"] != "" {
                        self.displayErrorLabel(text: "登陆中")
                        self.processLoginData(responseJSON: responseJSON)
                    }
                    else {
                        self.displayErrorLabel(text: "姓名或病案号错误")
                    }
                }
        }
    }
    
    
    func processLoginData(responseJSON: JSON) {
        if responseJSON["LoginId"] != "" {
            if self.isFirstTimeLogin() {
                /* If the user is also logging in for the first time, store the name and ID locally too */
                let loginObject = self.createLoginObjectFromTextFields(LoginId: responseJSON["LoginId"].string!)
                try! self.realm.write {
                    self.realm.add(loginObject)
                }
            }
            self.performSegue(withIdentifier: "toSelection", sender: self)
        }
        else {
            errorLabel.isHidden = false
        }
    }
}
