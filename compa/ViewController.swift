//
//  ViewController.swift
//  compa
//
//  Created by Vincent on 28/03/2018.
//  Copyright © 2018 Vincent. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    enum Method :String {
        case PUT
        case POST
        case DELETE
        case GET
    }
    
    let session = URLSession.shared //singleton with default behavior
    
    override func viewDidLoad() {
        super.viewDidLoad()
      
        GETAPIRequest(
            url: "https://jsonplaceholder.typicode.com/posts/1",
            success: { data in
                print(data)

            },
            error: { data in
                print(data)
            })

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    
    func GETAPIRequest(url : String, success: @escaping (_ data: Dictionary<String, AnyObject> )->Void, error: @escaping (_ data: Error )->Void ) {
        return APIRequest(url: url, method: Method.GET.rawValue, successHandler:success, errorHandler:error);
    }
    
    private func APIRequest(url:String, method: String, successHandler: @escaping (_ data: Dictionary<String, AnyObject> )->Void, errorHandler: @escaping (_ data: Error )->Void)  {
       
        var request = URLRequest(url: URL(string: url)!)
        request.httpMethod = method

        
        let task = session.dataTask(with: request, completionHandler: { data, response, error -> Void in
            if((error) != nil){
               errorHandler(error!)
            }
            else{
                do {
                    let json = try JSONSerialization.jsonObject(with: data!) as! Dictionary<String, AnyObject>
                    successHandler(json)
                } catch {
                    //call error handler with error instance ? or maybe throw 
                }
            }
            
        })
        
        task.resume()
        
       
    }
    


}

