//
//  CornorButton.swift
//  UserUtility
//
//  Created by IPS on 14/10/20.
//  Copyright © 2020 IPS. All rights reserved.
//

import UIKit

class CornorButton: UIButton {
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
        self.clipsToBounds = true
        self.layer.cornerRadius = 6.0
        self.layer.borderWidth = 1.5
        self.layer.borderColor = UIColor.lightGray.cgColor
    }
}
  
