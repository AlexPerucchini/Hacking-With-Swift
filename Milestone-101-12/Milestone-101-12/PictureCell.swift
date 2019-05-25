//
//  PictureCell.swift
//  Milestone-101-12
//
//  Created by Alex Perucchini on 5/24/19.
//  Copyright © 2019 Alex Perucchini. All rights reserved.
//

import UIKit

class PictureCell: UITableViewCell {
    
    @IBOutlet var imageView: UIImageView!
    @IBOutlet var name: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
