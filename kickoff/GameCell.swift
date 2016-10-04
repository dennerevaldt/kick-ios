//
//  GameCell.swift
//  kickoff
//
//  Created by Denner Evaldt on 30/09/16.
//  Copyright © 2016 Denner Evaldt. All rights reserved.
//

import UIKit

class GameCell: UITableViewCell {

    @IBOutlet weak var dateGame: UILabel!
    @IBOutlet weak var imageGame: UIImageView!
    @IBOutlet weak var hourGame: UILabel!
    @IBOutlet weak var nameGame: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
