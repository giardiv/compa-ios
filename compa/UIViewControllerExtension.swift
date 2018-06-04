//
//  Spinner.swift
//  compa
//
//  Created by m2sar on 28/05/2018.
//  Copyright © 2018 m2sar. All rights reserved.
//

import UIKit


extension UIViewController {
    
    class func displaySpinner(onView : UIView) -> UIView {
        let spinnerView = UIView.init(frame: onView.bounds)
        spinnerView.backgroundColor = UIColor.init(red: 0.5, green: 0.5, blue: 0.5, alpha: 0.5)
        let ai = UIActivityIndicatorView.init(activityIndicatorStyle: .whiteLarge)
        ai.startAnimating()
        ai.center = spinnerView.center
        
        DispatchQueue.main.async {
            spinnerView.addSubview(ai)
            onView.addSubview(spinnerView)
        }
        
        return spinnerView
    }
    
    class func removeSpinner(spinner :UIView) {
        DispatchQueue.main.async {
            spinner.removeFromSuperview()
        }
    }
    
    func alert(_ userMessage:String, title : String? = nil, handler: ((UIAlertAction) -> Void)? = nil){
        let myAlert = UIAlertController(title: title != nil ? title : "Alert", message:userMessage, preferredStyle: UIAlertControllerStyle.alert);
        myAlert.addAction(UIAlertAction(title:"Ok", style:UIAlertActionStyle.default, handler: handler));
        
        DispatchQueue.main.async {
            self.present(myAlert, animated:true, completion:nil);
        }
    }
    
    func checkToken(error: [String:Any], spinner: UIView? = nil) -> Bool{
        let code : Int = error["code"] as! Int
        
        if(code == 3002) {
            let mainStoryboard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
            let mainView: UIViewController = mainStoryboard.instantiateViewController(withIdentifier: "mainView")

            DispatchQueue.main.async {

                self.present(mainView, animated: true, completion: nil)
                UserDefaults.standard.removeObject(forKey: "token")
                UserDefaults.standard.synchronize()
                
                if let spinner = spinner {
                    UIViewController.removeSpinner(spinner: spinner)
                }
                
            }
            
            return false
        }
        return true
    
    }
    
}
