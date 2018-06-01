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

    let userRepository = UserRepository()
    var friendId = ""
    var status = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print(friendId)
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillAppear(_ animated: Bool){
        let sv = UIViewController.displaySpinner(onView: self.view)
        self.friendImage.layer.cornerRadius = self.friendImage.frame.size.width / 2
        
        let ctrl = self
        userRepository.get(identifier: friendId, result: { user in
            DispatchQueue.main.async(execute: {
                ctrl.friendImage.image = #imageLiteral(resourceName: "images") //TODO
                ctrl.friendName.text = user.name
                if let location = user.lastLocation {
                   ctrl.friendLastLocation.text = String(location.latitude)
                }
                
                ctrl.friendStatus.text = ctrl.status
                UIViewController.removeSpinner(spinner: sv)
            })
        }, error: {error in})
        
    }
    

    @IBAction func onCancelButtonTapped(_ sender: UIBarButtonItem) {
        self.dismiss(animated: true, completion: nil)
    }

}
