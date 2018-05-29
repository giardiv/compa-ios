//
//  ProfileTableViewCell.swift
//  compa
//
//  Created by m2sar on 22/05/2018.
//  Copyright © 2018 m2sar. All rights reserved.
//

import UIKit

class FriendCell: UITableViewCell {
    
    //MARK: Properties
   
    @IBOutlet weak var cellImage: UIImageView!
    @IBOutlet weak var cellName: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
}
