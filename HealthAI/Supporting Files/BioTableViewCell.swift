//
//  BioTableViewCell.swift
//  HealthAI
//
//  Created by Feng Guo on 10/28/18.
//  Copyright © 2018 Team9. All rights reserved.
//

import UIKit

class BioTableViewCell: UITableViewCell {

    @IBOutlet var bioLabel: UILabel!
    
    @IBOutlet var numberLabel: UILabel!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
