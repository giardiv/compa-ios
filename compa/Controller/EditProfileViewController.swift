//
//  EditProfileViewController.swift
//  compa
//
//  Created by m2sar on 23/05/2018.
//  Copyright © 2018 m2sar. All rights reserved.
//

import UIKit

class EditProfileViewController: UIViewController{
    
    
    @IBOutlet weak var updateUserImage: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.updateUIView()
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    func updateUIView(){
        self.updateUserImage.layer.cornerRadius = self.updateUserImage.frame.size.width / 2
    }
    
    @IBAction func updateUserImageTapped(_ sender: Any) {
        print("todo")
    }
}
