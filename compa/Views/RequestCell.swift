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
    
    var requestAction: ((String) -> Void)? = nil
    
    @IBAction func confirmRequest(_ sender: Any) {
        requestAction!("confirm")
    }
    
    
    @IBAction func rejectRequest(_ sender: Any) {
        requestAction!("reject")
    }
}
