//
//  MainViewController.swift
//  compa
//
//  Created by m2sar on 04/06/2018.
//  Copyright © 2018 m2sar. All rights reserved.
//

import UIKit


class MainViewController : UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if UserDefaults.standard.value(forKey: "token") != nil {
            self.performSegue(withIdentifier:"mainToMap", sender: self)
        }
    }
    
    
}
