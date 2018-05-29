//
//  FriendProfileViewController.swift
//  compa
//
//  Created by m2sar on 23/05/2018.
//  Copyright © 2018 m2sar. All rights reserved.
//

import UIKit

class FriendProfileViewController: UIViewController {
    
    @IBOutlet weak var friendName: UILabel!
    @IBOutlet weak var friendLastLocation: UILabel!
    @IBOutlet weak var friendStatus: UILabel!
    @IBOutlet weak var friendImage: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.updateUIView()
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    func updateUIView(){
        self.friendImage.layer.cornerRadius = self.friendImage.frame.size.width / 2
    }
}
