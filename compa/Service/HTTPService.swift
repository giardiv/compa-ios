import UIKit

class HTTPService {
    
    enum Method :String {
        case PUT
        case POST
        case DELETE
        case GET
    }
    
    let session = URLSession.shared //singleton with default behavior
    
    let baseURL = "https://jsonplaceholder.typicode.com/posts/1"
    
    /*get(
     url: ,
     success: { data in
     print(data)
     
     },
     error: { data in
     print(data)
     })*/
    
    
    func get(url : String, success: @escaping (_ data: [String:Any] )->Void, error: @escaping (_ data: Error )->Void ) {
        return APIRequest(url: url, method: Method.GET.rawValue, successHandler:success, errorHandler:error);
    }
    
    
    func post(url : String, data : [String:Any], success: @escaping (_ data: [String:Any] )->Void, error: @escaping (_ data: Error )->Void ) {
        return APIRequest(url: url, method: Method.POST.rawValue,  data:data, successHandler:success, errorHandler:error);
    }
    
    private func APIRequest(url: String, method: String, data: [String:Any]? = nil, successHandler: @escaping (_ data: [String:Any] )->Void, errorHandler: @escaping (_ data: Error )->Void) {
        
        print(url)
        var request = URLRequest(url: URL(string: url)!)
        request.httpMethod = method
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        
        if let body = data {
            do {
                request.httpBody = try JSONSerialization.data(withJSONObject: body, options: .prettyPrinted) //remove opt
            } catch let error {
                print(error.localizedDescription)
            }
            
        }
    
        let task = session.dataTask(with: request, completionHandler: { data, response, error -> Void in
            if((error) != nil){
                errorHandler(error!)
            }
            else{
                do {
                    let json = try JSONSerialization.jsonObject(with: data!) as! [String:Any]
                    successHandler(json)
                } catch {
                    //call error handler with error instance ? or maybe throw
                }
            }
            
        })
        
        task.resume()
        
    }
    
    
}

