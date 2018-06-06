//
//  UserWishListAnnotationView.swift
//  CustomPinsMap
//
//  Created by m2sar on 31/05/2018.
//  Copyright © 2018 Ignacio Nieto Carvajal. All rights reserved.
//

import UIKit
import MapKit

private let kUserMapPinImage = UIImage(named: "mapPin")!
private let kUserMapAnimationTime = 0.300

class UserAnnotationView: MKAnnotationView {
    // data
    weak var UserDetailDelegate: UserDetailMapViewDelegate?
    weak var customCalloutView: UserDetailMapView?
    override var annotation: MKAnnotation? {
        willSet { customCalloutView?.removeFromSuperview() }
    }
    
    // MARK: - life cycle
    
    init(annotation: MKAnnotation?, reuseIdentifier: String?, image: UIImage? = nil) {
        super.init(annotation: annotation, reuseIdentifier: reuseIdentifier)
        self.canShowCallout = false
        self.image = image != nil ? image : kUserMapPinImage
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.canShowCallout = false // This is important: Don't show default callout.
        self.image = kUserMapPinImage
    }
    
    // MARK: - callout showing and hiding
    // Important: the selected state of the annotation view controls when the
    // view must be shown or not. We should show it when selected and hide it
    // when de-selected.
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        if selected {
            self.customCalloutView?.removeFromSuperview() // remove old custom callout (if any)
            
            if let newCustomCalloutView = loadUserDetailMapView() {
                // fix location from top-left to its right place.
                newCustomCalloutView.frame.origin.x -= newCustomCalloutView.frame.width / 2.0 - (self.frame.width / 2.0)
                newCustomCalloutView.frame.origin.y -= newCustomCalloutView.frame.height
                
                // set custom callout view
                self.addSubview(newCustomCalloutView)
                self.customCalloutView = newCustomCalloutView
                
                // animate presentation
                if animated {
                    self.customCalloutView!.alpha = 0.0
                    UIView.animate(withDuration: kUserMapAnimationTime, animations: {
                        self.customCalloutView!.alpha = 1.0
                    })
                }
            }
        } else {
            if customCalloutView != nil {
                if animated { // fade out animation, then remove it.
                    UIView.animate(withDuration: kUserMapAnimationTime, animations: {
                        self.customCalloutView!.alpha = 0.0
                    }, completion: { (success) in
                        self.customCalloutView!.removeFromSuperview()
                    })
                } else { self.customCalloutView!.removeFromSuperview() } // just remove it.
            }
        }
    }
    
    func loadUserDetailMapView() -> UserDetailMapView? {
        if let views = Bundle.main.loadNibNamed("UserDetailMapView", owner: self, options: nil) as? [UserDetailMapView], views.count > 0 {
            let UserDetailMapView = views.first!
            UserDetailMapView.delegate = self.UserDetailDelegate
            if let UserAnnotation = annotation as? UserAnnotation {
                UserDetailMapView.configureWithUser(givenUser: UserAnnotation.user)
            }
            return UserDetailMapView
        }
        return nil
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        self.customCalloutView?.removeFromSuperview()
    }
    
    // MARK: - Detecting and reaction to taps on custom callout.
    
    override func hitTest(_ point: CGPoint, with event: UIEvent?) -> UIView? {
        // if super passed hit test, return the result
        if let parentHitView = super.hitTest(point, with: event) { return parentHitView }
        else { // test in our custom callout.
            if customCalloutView != nil {
                return customCalloutView!.hitTest(convert(point, to: customCalloutView!), with: event)
            } else { return nil }
        }
    }
}
