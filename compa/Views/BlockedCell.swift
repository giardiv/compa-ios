//
//  BlockedCell.swift
//  compa
//
//  Created by m2sar on 24/05/2018.
//  Copyright © 2018 m2sar. All rights reserved.
//

import UIKit

class BlockedCell : UITableViewCell {
    
    
    
    @IBOutlet weak var cellImage: UIImageView!
    @IBOutlet weak var cellName: UILabel!
    
    var blockUserAction: (() -> Void)? = nil
    
    @IBAction func deblockUserTapped(_ sender: UIButton) {
        blockUserAction!()
    }
}
