//
//  retractKeyboardExtension.swift
//  TaiChi
//
//  Created by Peteski Shi on 7/2/19.
//  Copyright © 2019 Petech. All rights reserved.
//

import UIKit

extension UIViewController {
    func hideKeyboard() {
        let tap = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        view.addGestureRecognizer(tap)
    }
    
    @objc func dismissKeyboard() {
        view.endEditing(true)
    }
}
