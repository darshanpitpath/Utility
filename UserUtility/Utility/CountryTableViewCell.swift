//
//  CountryTableViewCell.swift
//  UserUtility
//
//  Created by IPS on 14/10/20.
//  Copyright © 2020 IPS. All rights reserved.
//

import UIKit

class CountryTableViewCell: UITableViewCell {
    @IBOutlet weak var lblCountryCode:UILabel!
    @IBOutlet weak var lblCountryDetail:UILabel!
    @IBOutlet weak var imageCountry:UIImageView!
    @IBOutlet weak var lblTick:UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        self.selectionStyle = .none
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
