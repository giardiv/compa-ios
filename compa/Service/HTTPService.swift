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
    
    let root: String
    
    init(){
        let path = Bundle.main.path(forResource: "Info", ofType: "plist")!
        let dict = NSDictionary(contentsOfFile: path)!
        root = dict["root"] as! String
    }
    
    /*get(
     url: ,
     success: { data in
     print(data)
     
     },
     error: { data in
     print(data)
     })*/
    
    
    func get(isRelative:Bool, isAuthenticated: Bool, authToken: String? = nil, url : String, success: @escaping (_ data: [String:Any] )->Void, error: @escaping (_ data: [String:Any] )->Void ) {
        
        return APIRequest(isRelative: isRelative, isAuthenticated: isAuthenticated, url: url, method: Method.GET.rawValue, successHandler:success, errorHandler:error);
    }
    
    
    func post(isRelative:Bool, isAuthenticated: Bool, url : String, data : [String:Any], success: @escaping (_ data: [String:Any] )->Void, error: @escaping (_ data: [String:Any] )->Void ) {
        return APIRequest(isRelative: isRelative, isAuthenticated: isAuthenticated, url: url, method: Method.POST.rawValue,  data:data, successHandler:success, errorHandler:error);
    }
    
    
    private func APIRequest(isRelative: Bool, isAuthenticated: Bool, url: String, method: String, data: [String:Any]? = nil, successHandler: @escaping (_ data: [String:Any] )->Void, errorHandler: @escaping (_ data: [String:Any] )->Void) {

        let url = isRelative ? root + url : url
        var request = URLRequest(url: URL(string: url)!)
        request.httpMethod = method
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")

        if isAuthenticated {
            guard let token = UserDefaults.standard.string(forKey: "token") else {
                //errorHandler(NSError(coder: "you are not authenticated")) TODO
                return
            }
            
            request.addValue(token, forHTTPHeaderField: "Authorization")
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
            
                    //print(String(data: data!, encoding: String.Encoding.utf8)!)
                    
                    let json = try JSONSerialization.jsonObject(with: data!) //MIGHT BE AN ARRAY AND NOT A DIC
                    let handler = statusCode >= 400 ? errorHandler : successHandler
                    
                    if let json = json as? Array<Any> {
                        handler(json.toDictionary())
                    }
                    else{
                        handler(json as! [String:Any])
                    }
            
                    
                 
                    
                    
                } catch {
                    let dic = ["message" : "invalid json format", "code" : 400] as [String:Any]
                    errorHandler(dic)
                }
            }
            
        })
        
        task.resume()
        
    }
    
    
}


extension Array {
    public func toDictionary() -> [String:Any] {
        var dict = [String:Any]()
        for (index, element) in self.enumerated() {
            dict[String(index)] = element
        }
        return dict
    }
}
