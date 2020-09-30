//
//  ProductCell.swift
//  ETicaret
//
//  Created by melisa öztürk on 30.09.2020.
//  Copyright © 2020 melisa öztürk. All rights reserved.
//

import UIKit

class ProductCell: UITableViewCell {

    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet weak var lblPrice: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

    }
    
}
