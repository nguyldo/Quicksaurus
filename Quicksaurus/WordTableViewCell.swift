//
//  WordTableViewCell.swift
//  Quicksaurus
//
//  Created by Nguyen Do on 7/30/17.
//  Copyright © 2017 Nguyen Do. All rights reserved.
//

import UIKit

class WordTableViewCell: UITableViewCell {

    @IBOutlet var wordLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
