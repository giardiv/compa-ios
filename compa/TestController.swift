//
//  TestController.swift
//  compa
//
//  Created by m2sar on 16/05/2018.
//  Copyright © 2018 m2sar. All rights reserved.
//

import Foundation


class TestController {
    override func viewDidAppear(_ animated: Bool)
    {
        let isUserLoggedIn = UserDefaults.standard.bool(forKey: "isUserLoggedIn")
        
        if(!isUserLoggedIn)
        {
            self.performSegue(withIdentifier:"loginView", sender: self)
        }
        
    }
    
    @IBAction func logoutButtonTapped(_ sender: Any) {
        UserDefaults.standard.set(false, forKey: "isUserLoggedIn");
        UserDefaults.standard.synchronize();
        
        self.performSegue(withIdentifier:"loginView", sender: self)
    }
}
