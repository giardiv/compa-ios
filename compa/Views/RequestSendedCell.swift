//
//  RequestSendedCell.swift
//  compa
//
//  Created by m2sar on 06/06/2018.
//  Copyright © 2018 m2sar. All rights reserved.
//

import UIKit

class RequestSendedCell: UITableViewCell {
    
    @IBOutlet weak var cellName: UILabel!
    @IBOutlet weak var cellImage: UIImageView!
    
    var action: (() -> Void?)? = nil
    
    @IBAction func requestButton(_ sender: Any) {
        action!()
    }
}
