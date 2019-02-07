//
//  buttonShadowExtension.swift
//  TaiChi
//
//  Created by Peteski Shi on 7/2/19.
//  Copyright © 2019 Petech. All rights reserved.
//

import UIKit

extension UIButton {
    func getShadow(button: UIButton) {
        button.layer.shadowColor = UIColor(red: 0, green: 0, blue: 0, alpha: 1).cgColor
        button.layer.shadowOffset = CGSize(width: 0, height: 1.75)
        button.layer.shadowRadius = 1.7
        button.layer.shadowOpacity = 0.45
    }
}
