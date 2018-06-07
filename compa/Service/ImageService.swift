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

    func postImage( isAuthenticated: Bool, url: String, imageUpdate: NSData, successHandler: @escaping (_ data: [String:Any] )->Void, errorHandler: @escaping (_ data: [String:Any] )->Void){
        
        let url = HTTPService.root + url
        var request = URLRequest(url: URL(string: url)!)
        let boundary = "unique-consistent-string"
        
        request.httpMethod = "POST"
        request.setValue("multipart/form-data; boundary=\(boundary)", forHTTPHeaderField: "Content-Type")
        
        if isAuthenticated {
            guard let token = UserDefaults.standard.string(forKey: "token") else {
                errorHandler(["code":3002])
                return
            }
            
            request.addValue(token, forHTTPHeaderField: "Authorization")
            
        }
        
        let body = NSMutableData()
        
        // add image data
        body.append("--\(boundary)\r\n".data(using: String.Encoding.utf8)!)
        body.append("Content-Disposition: form-data; name=\("imageFormKey"); filename=imageName.png\r\n".data(using: String.Encoding.utf8)!)
        body.append("Content-Type: image/png\r\n\r\n".data(using: String.Encoding.utf8)!)
        body.append(imageUpdate as Data)
        body.append("\r\n".data(using: String.Encoding.utf8)!)
        body.append("--\(boundary)--\r\n".data(using: String.Encoding.utf8)!)
        request.httpBody = body as Data
        
        
        let task = URLSession.shared.dataTask(with: request, completionHandler: { data, response, error -> Void in
            
            let httpResponse = response as! HTTPURLResponse
            let statusCode = httpResponse.statusCode
                      if let error = error {
                errorHandler(["message" : error.localizedDescription, "code" : statusCode] as [String:Any])
            }
                
            else{
                do {
                    print(String(data: data!, encoding: String.Encoding.utf8)!)
                    
                    let json = try JSONSerialization.jsonObject(with: data!)
                    let handler = statusCode >= 400 ? errorHandler : successHandler
                    
                    if let json = json as? Array<Any> {
                        handler(json.toDictionary())
                    }
                    else{
                        handler(json as! [String:Any])
                    }
                    
                } catch {
                    errorHandler(["message" : "an error occured with the request", "code" : 400] as [String:Any])
                }
                
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
