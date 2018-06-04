//
//  ImageService.swift
//  compa
//
//  Created by m2sar on 04/06/2018.
//  Copyright © 2018 m2sar. All rights reserved.
//

import UIKit

class ImageService {
    
    func downloadImage(url: String, successHandler: @escaping (_ data: UIImage )->Void, errorHandler: @escaping (_ data: [String:Any])->Void ) {
        
        var request = URLRequest(url: URL(string: url)!)
        request.httpMethod = "GET"

        let task = URLSession.shared.dataTask(with: request, completionHandler: { data, response, error -> Void in
            if let data = data {
                let img = UIImage(data: data)
                if let image = img {
                    successHandler(image)
                }
                else{
                    errorHandler(["message": "Could not load image from url"] as [String:Any])
                }
            }
            else{
                errorHandler(["message": "Could not load image from url"] as [String:Any])
            }
        
        })
        
        task.resume()

    }
    
    //Example call
    
    /*
 
         ImageService().downloadImage(
         url: "https://cdn.pixabay.com/photo/2016/06/18/17/42/image-1465348_960_720.jpg"
         successHandler: {data in }, //you get an UIImage
         errorHandler:  {data in }
         )
     
     */
}
