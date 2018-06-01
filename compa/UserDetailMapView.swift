//
//  UserDetailMapView.swift
//  CustomPinsMap
//
//  Created by Ignacio Nieto Carvajal on 6/12/16.
//  Copyright © 2016 Ignacio Nieto Carvajal. All rights reserved.
//

import UIKit

protocol UserDetailMapViewDelegate: class {
    func detailsRequestedForUser(User: User)
}

class UserDetailMapView: UIView {
    // outlets
    @IBOutlet weak var backgroundContentButton: UIButton!
    @IBOutlet weak var UserImageView: UIImageView!
    @IBOutlet weak var UserName: UILabel!
    @IBOutlet weak var seeDetailsButton: UIButton!
    
    // data
    var User: User!
    weak var delegate: UserDetailMapViewDelegate?
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    @IBAction func seeDetails(_ sender: Any) {
        delegate?.detailsRequestedForUser(User: User)
    }
    
    func configureWithUser(User: User) {
        self.User = User
        UserImageView.image = #imageLiteral(resourceName: "person-profile")
        UserName.text = User.name
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
