//
//  RequestCell.swift
//  compa
//
//  Created by m2sar on 24/05/2018.
//  Copyright © 2018 m2sar. All rights reserved.
//

import UIKit

class RequestCell: UITableViewCell {
    

    @IBOutlet weak var cellImage: UIImageView!
    @IBOutlet weak var cellName: UILabel!
    
    var confirmRequestAction: (() -> Void)? = nil
    
    @IBAction func confirmRequest(_ sender: Any) {
        confirmRequestAction!();
    }
}
