//
//  UserDetailMapView.swift
//  CustomPinsMap
//
//  Created by Ignacio Nieto Carvajal on 6/12/16.
//  Copyright © 2016 Ignacio Nieto Carvajal. All rights reserved.
//

import UIKit

protocol UserDetailMapViewDelegate: class {
    func detailsRequestedForUser(user: User)
    func dealWithTapped(user:User)
}

class UserDetailMapView: UIView {
    // outlets
    @IBOutlet weak var backgroundContentButton: UIButton!
    @IBOutlet weak var UserImageView: UIImageView!
    @IBOutlet weak var UserName: UILabel!
    @IBOutlet weak var seeDetailsButton: UIButton!
    @IBOutlet weak var subtitle: UILabel!
    
    // data
    var user: User!
    weak var delegate: UserDetailMapViewDelegate?
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    @IBAction func seeDetails(_ sender: Any) {
        delegate?.detailsRequestedForUser(user: user)
    }
    
    @IBAction func detailsButtonTapped(_ sender: UIButton) {
        delegate?.dealWithTapped(user : user!)
    }
    
    
    func configureWithUser(givenUser: User) {
        self.user = givenUser
        UserImageView.image = user.image != nil ? user.image : #imageLiteral(resourceName: "person-profile")
        UserName.text = givenUser.name
        subtitle.text = givenUser.login
    }
    
    // MARK: - Hit test. We need to override this to detect hits in our custom callout.
    override func hitTest(_ point: CGPoint, with event: UIEvent?) -> UIView? {
        // Check if it hit our annotation detail view components.

        // details button
        if let result = seeDetailsButton.hitTest(convert(point, to: seeDetailsButton), with: event) {
            return result
        }

        // fallback to our background content view
        return backgroundContentButton.hitTest(convert(point, to: backgroundContentButton), with: event)
    }
 
}
