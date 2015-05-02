//
//  ItemTableViewCell.swift
//  SwiftApp
//
//  Created by Diego dos Santos on 4/15/15.
//  Copyright (c) 2015 Diego dos Santos. All rights reserved.
//

import UIKit

class ItemTableViewCell: UITableViewCell {

    @IBOutlet weak var name: UILabel!
    @IBOutlet weak var date: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }

}
