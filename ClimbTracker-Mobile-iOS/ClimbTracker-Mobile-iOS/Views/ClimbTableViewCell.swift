//
//  ClimbTableViewCell.swift
//  ClimbTracker-Mobile-iOS
//
//  Created by Matthew Richardson on 1/26/18.
//  Copyright © 2018 Matthew Richardson. All rights reserved.
//

import UIKit

class ClimbTableViewCell: UITableViewCell {

    @IBOutlet weak var locationLabel: UILabel!
    @IBOutlet weak var climbTypeLabel: UILabel!
    @IBOutlet weak var gradeLabel: UILabel!
    @IBOutlet weak var completionTypeLabel: UILabel!
    @IBOutlet weak var countLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
