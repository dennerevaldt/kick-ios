//
//  ScheduleCell.swift
//  kickoff
//
//  Created by Denner Evaldt on 30/09/16.
//  Copyright © 2016 Denner Evaldt. All rights reserved.
//

import UIKit

class ScheduleCell: UITableViewCell {

    @IBOutlet weak var nameCourtSchedule: UILabel!
    @IBOutlet weak var horarySchedule: UILabel!
    @IBOutlet weak var dateSchedule: UILabel!
    @IBOutlet weak var imageSchedule: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
