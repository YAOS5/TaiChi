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
    func checkCredentialsWithCloudDB(Name: String?, ID: String?) {
        /* If nothing is returned, display error label and terminate the function */
        if (Name == "") || (ID == "") {
            errorLabel.isHidden = false
            return
        }
        
        var Parameters = Dictionary<String,String>()
        Parameters["UserName"] = Name
        Parameters["PassWord"] = ID
        
        let loginURL = "http://58.221.127.78:9001/api/Login/LoginOn"
        AF.request(loginURL, method: .post, parameters: Parameters, encoding: URLEncoding.httpBody,
                   headers: ["Content-Type": "application/x-www-form-urlencoded"]).responseJSON
            { response in
                
                /* Extracting the JSON */
                let responseJSON : JSON = JSON(response.result.value!)
                /* Now we need to check if it is correct */
                if responseJSON["isTrue"].string == "true" {
                    if self.isFirstTimeLogin() {
                        /* If the user is also logging in for the first time,
                         store the name and ID locally too */
                        let loginObject = self.createLoginObjectFromTextFields(LoginId: responseJSON["LoginId"].string!)
                        try! self.realm.write {
                            self.realm.add(loginObject)
                        }
                    }
                    self.performSegue(withIdentifier: "toSelection", sender: self)
                }
                else {
                    self.errorLabel.isHidden = false
                }
        }
    }
}
