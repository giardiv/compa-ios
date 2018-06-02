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
    @IBOutlet weak var friendImage: UIImageView!
    @IBOutlet weak var buttonStatus: UIButton!

    let userRepository = UserRepository()
    let friendshipRepo = FriendshipRepository()
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
        print(friendId)
        let ctrl = self
        userRepository.get(identifier: friendId, result: { user in
            DispatchQueue.main.async(execute: {
                ctrl.friendImage.image = #imageLiteral(resourceName: "images") //TODO
                ctrl.friendName.text = user.name
                if let location = user.lastLocation {
                   ctrl.friendLastLocation.text = String(location.latitude)
                }
                ctrl.buttonStatus?.setTitle("▾ " + ctrl.status, for: UIControlState.normal)
                UIViewController.removeSpinner(spinner: sv)
            })
        }, error: {error in})
        
    }
    

    @IBAction func onCancelButtonTapped(_ sender: UIBarButtonItem) {
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func displayActionSheet(_ sender: Any) {
        let ctrl = self
        let optionMenu = UIAlertController(title: nil, message: "Choose Option", preferredStyle: .actionSheet)
        //VOIR POURQUOI ON NE RECUPERE PAS LE FRIEND A PARTIR DE PROFILEVIEW
        
        let deleteAction = UIAlertAction(title: "Delete", style: .default, handler: { (alert: UIAlertAction!) -> Void in
            ctrl.friendshipRepo.deleteFriendship(
                friendId: ctrl.friendId,
                result: { data in
                    DispatchQueue.main.async {
                        ctrl.alert((ctrl.friendName?.text)! + " is deleted")
                        ctrl.dismiss(animated: true, completion: nil)
                    }
                }, error: { error in
                    ctrl.alert(error["message"] as! String)
                }
            )
        })
        
        let blockAction = UIAlertAction(title: "Block", style: .default, handler: { (alert: UIAlertAction!) -> Void in
            ctrl.friendshipRepo.blockUser(
                friendId: ctrl.friendId,
                result: { data in
                    DispatchQueue.main.async {
                        ctrl.alert((ctrl.friendName?.text)! + " is blocked !")
                        ctrl.dismiss(animated: true, completion: nil)
                    }
                }, error: { error in
                    ctrl.alert(error["message"] as! String)
                }
            )
        })
        
        let rejectRequestAction = UIAlertAction(title: "Reject", style: .default, handler: { (alert: UIAlertAction!) -> Void in
            ctrl.friendshipRepo.rejectFriendshipRequest(
                friendId: ctrl.friendId,
                result: { data in
                    DispatchQueue.main.async {
                        ctrl.alert("The friend request has been rejected :)")
                        ctrl.dismiss(animated: true, completion: nil)
                    }
                }, error: { error in
                    ctrl.alert(error["message"] as! String)
                }
            )
        })
        
        let confirmRequestAction = UIAlertAction(title: "Confirm", style: .default, handler: { (alert: UIAlertAction!) -> Void in
            ctrl.friendshipRepo.confirmFriendshipRequest(
                friendId: ctrl.friendId,
                result: { data in
                    DispatchQueue.main.async {
                        ctrl.alert("You are now friend with " + (ctrl.friendName?.text)! + " !")
                        ctrl.buttonStatus?.setTitle("▾ Accepted", for: UIControlState.normal)
                    }
                }, error: { error in
                    ctrl.alert(error["message"] as! String)
                }
            )
        })
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: { (alert: UIAlertAction!) -> Void in
            print("Cancelled")
        })
        
        
        if(self.buttonStatus?.titleLabel?.text == "▾ Awaiting") {
            optionMenu.addAction(confirmRequestAction)
            optionMenu.addAction(rejectRequestAction)
        } else if (self.buttonStatus?.titleLabel?.text == "▾ Accepted") {
            optionMenu.addAction(blockAction)
            optionMenu.addAction(deleteAction)
        }
        
        optionMenu.addAction(cancelAction)
        self.present(optionMenu, animated: true, completion: nil)
    }

}
