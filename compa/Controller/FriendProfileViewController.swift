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

    var friendId = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print(friendId)
        self.friendImage.layer.cornerRadius = self.friendImage.frame.size.width / 2
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewDidAppear(_ animated: Bool){
        //self.performSegue(withIdentifier:"mainToMap", sender: self)
    }

    @IBAction func onCancelButtonTapped(_ sender: UIBarButtonItem) {
        self.dismiss(animated: true, completion: nil)
    }

}
