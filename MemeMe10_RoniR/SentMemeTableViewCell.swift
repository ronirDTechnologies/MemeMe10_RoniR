//
//  SentMemeTableViewCell.swift
//  MemeMe10_RoniR
//
//  Created by Roni Rozenblat on 7/5/16.
//  Copyright © 2016 Roni Rozenblat. All rights reserved.
//

import UIKit

class SentMemeTableViewCell: UITableViewCell {

    @IBOutlet weak var sentMemeTableCellImage: UIImageView!
    @IBOutlet weak var sentMemeTableCellLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
