//
//  CombatCellViewCell.swift
//  CombatMatrixiOS
//
//  Created by Paul Hebert on 7/9/18.
//  Copyright © 2018 Paul Hebert. All rights reserved.
//

import UIKit

class CombatViewCell: UITableViewCell {

    @IBOutlet weak var name: UILabel!
    @IBOutlet weak var remainingAttacks: UILabel!
    @IBOutlet weak var totalAttacks: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
