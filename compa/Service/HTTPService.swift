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
    
    
    func get(isAuthenticated: Bool, authToken: String? = nil, url : String, success: @escaping (_ data: [String:Any] )->Void, error: @escaping (_ data: [String:Any] )->Void ) {
        
        return APIRequest(isAuthenticated: isAuthenticated, url: url, method: Method.GET.rawValue, successHandler:success, errorHandler:error);
    }
    
    
    func post(isAuthenticated: Bool, url : String, data : [String:Any], success: @escaping (_ data: [String:Any] )->Void, error: @escaping (_ data: [String:Any] )->Void ) {
        return APIRequest(isAuthenticated: isAuthenticated, url: url, method: Method.POST.rawValue,  data:data, successHandler:success, errorHandler:error);
    }
    
    
    private func APIRequest(isAuthenticated: Bool, url: String, method: String, data: [String:Any]? = nil, successHandler: @escaping (_ data: [String:Any] )->Void, errorHandler: @escaping (_ data: [String:Any] )->Void) {

        var request = URLRequest(url: URL(string: url)!)
        request.httpMethod = method
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")

        if isAuthenticated {
            guard let token = UserDefaults.standard.string(forKey: "token") else {
                //errorHandler(NSError(coder: "you are not authenticated")) TODO
                return
            }
            
            request.addValue(token, forHTTPHeaderField: "")
        }
        
        
        if let body = data {
            do {
                request.httpBody = try JSONSerialization.data(withJSONObject: body, options: .prettyPrinted) //remove opt
            } catch let error {
                print(error.localizedDescription)
            }
            
        }
    
        let task = session.dataTask(with: request, completionHandler: { data, response, error -> Void in
         
            let httpResponse = response as! HTTPURLResponse
            let statusCode = httpResponse.statusCode
            
            if let error = error {
                let dic = ["message" : error.localizedDescription, "code" : statusCode] as [String:Any]
                errorHandler(dic)
            }
                
            else{
                do {
                    
                    let json = try JSONSerialization.jsonObject(with: data!) as! [String:Any]
                    let handler = statusCode >= 400 ? errorHandler : successHandler
                    handler(json)
                    
                } catch {
                    let dic = ["message" : "invalid json format", "code" : 400] as [String:Any]
                    errorHandler(dic)
                }
            }
            
        })
        
        task.resume()
        
    }
    
    
}

