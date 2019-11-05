//
//  HeaderTableViewCell.swift
//  Quicksaurus
//
//  Created by Nguyen Do on 8/1/17.
//  Copyright © 2017 Nguyen Do. All rights reserved.
//

import UIKit

class HeaderTableViewCell: UITableViewCell {

    @IBOutlet var headerLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
