//
//  NetworkManager.swift
//  CountDown
//
//  Created by Rodrigo Hernández Gómez on 04/12/2020.
//

import Foundation

class Post: Codable {
    
    let userId: Int
    let title: String
    let body: String
    
    init(title: String, body: String, userId: Int) {
        self.title = title
        self.body = body
        self.userId = userId
    }
    
    
}

class Network: PicsumAPI {
    
        
    static var shared: Network = Network()
    
    func newPost(){
        
        let headers = ["content-type": "application/json; charset=UTF-8"]

        let newPost = Post(title: "Nuevo Post", body: "vete a hacer la compra", userId: 3)
        
        let encoder = JSONEncoder.init()
        
        var postData: Data!
        
        do {
            let postSerilized = try! encoder.encode(newPost)
            postData = try! Data(encoder.encode(newPost))
        }catch{
            print(error)
        }

        let request = NSMutableURLRequest(url: NSURL(string: "https://jsonplaceholder.typicode.com/posts")! as URL,
                                                cachePolicy: .useProtocolCachePolicy,
                                            timeoutInterval: 10.0)
        request.httpMethod = "POST"
        request.allHTTPHeaderFields = headers
        request.httpBody = postData as Data

        let session = URLSession.shared
        let dataTask = session.dataTask(with: request as URLRequest, completionHandler: { (data, response, error) -> Void in
          if (error != nil) {
            print(error)
          } else {
            let httpResponse = response as? HTTPURLResponse
            print(httpResponse)
          }
        })

        dataTask.resume()
        
    }
    
    func getPhoto(completionHandler: @escaping (_ data: Data) -> Any) {
        
        //1 Define the Request
        var urlRequest = URLRequest(url: URL(string: "https://picsum.photos/200/300")!)
        
        urlRequest.httpMethod = "GET"
        
        //2 Set addiotional headers
        urlRequest.addValue("application/json", forHTTPHeaderField: "Accept-Language")
        
        
        
        URLSession.shared.dataTask(with: URL(string: "https://picsum.photos/200/300")!){
            data,response,error in
        
            
            completionHandler(data!)
            
        }.resume()
        
    }
    
    func getPost(completionHandler: @escaping (_ data: Data) -> Any){
        var urlRequest = URLRequest(url: URL(string: "https://jsonplaceholder.typicode.com/posts")!)
        
        urlRequest.httpMethod = "GET"
        
        urlRequest.addValue("application/json", forHTTPHeaderField: "Accept-Language")
        
        URLSession.shared.dataTask(with: URL(string: "https://jsonplaceholder.typicode.com/posts")!){
            data,response,error in
            
            completionHandler(data!)
        }.resume()
    }
    
    func postPost(completionHandler: @escaping (_ data: Data) -> Any){
        var urlRequest = URLRequest(url: URL(string: "https://jsonplaceholder.typicode.com/posts")!)
        
        urlRequest.httpMethod = "POST"
        
        let parameters: [String: Any] = [
            "userId": 1,
            "id": 13,
            "title": "Jack & Jill",
            "body": "gem gem gem"
        ]
        //urlRequest.httpBody = parameters.percentEncoded()
        
        urlRequest.addValue("application/json", forHTTPHeaderField: "Accept-Language")
        
        URLSession.shared.dataTask(with: URL(string: "https://jsonplaceholder.typicode.com/posts")!){
            data,response,error in
            guard let data = data,
                let response = response as? HTTPURLResponse,
            error == nil else {
                print ("error", error ?? "Unknown error")
                return
            }

            guard (200 ... 299) ~= response.statusCode else {
                print("statusCode should be 2xx, but is \(response.statusCode)")
                print("response = \(response)")
                return
            }

            let responseString = String(data: data, encoding: .utf8)
            print("responseString = \(String(describing: responseString))")
            
            completionHandler(data)
        }.resume()
    }
    
    func putPost1(completionHandler: @escaping (_ data: Data) -> Any){
        
        var urlRequest = URLRequest(url: URL(string: "https://jsonplaceholder.typicode.com/posts/1")!)
       
        urlRequest.addValue("application/json", forHTTPHeaderField: "Content-Type")
        
        urlRequest.httpMethod = "PUT"

        _ = URLSession(configuration:URLSessionConfiguration.default, delegate: nil, delegateQueue: nil)
        let data = "username=self@gmail.com&password=password".data(using: String.Encoding.utf8)
        urlRequest.httpBody = data
        
        URLSession.shared.dataTask(with: URL(string: "https://jsonplaceholder.typicode.com/posts/1")!){
            data,response,error in
            
            if error != nil {
                
            } else {
                let jsonStr = NSString(data: data!, encoding: String.Encoding.utf8.rawValue)
                print("Parsed JSON: '\(String(describing: jsonStr))'")
            }
        }.resume()
    }
        

        func patchPost1(completionHandler: @escaping (_ data: Data) -> Any){

             var urlRequest = URLRequest(url: URL(string: "https://jsonplaceholder.typicode.com/posts/1")!)
            
             urlRequest.addValue("application/json", forHTTPHeaderField: "Content-Type")
             
             urlRequest.httpMethod = "PATCH"
            
            do{
                let json: [String: Any] = ["status": "test"]
                let jsonData = try? JSONSerialization.data(withJSONObject: json)
                urlRequest.httpBody = jsonData
                print("jsonData: ", String(data: urlRequest.httpBody!, encoding: .utf8) ?? "no body data")
            }catch {
                print("ERROR")
            }
            
            URLSession.shared.dataTask(with: URL(string: "https://jsonplaceholder.typicode.com/posts/1")!){
            data,response,error in
                
            if error != nil {
                print("error=\(String(describing: error))")
                completionHandler(data!)
                return
            }

            let responseString = NSString(data: data!, encoding:String.Encoding.utf8.rawValue)
                print("responseString = \(String(describing: responseString))")
                completionHandler(data!)
            return
                
            }.resume()
            
        }
        
        func deletePost1(completionHandler: @escaping (_ data: Data) -> Any){
            var urlRequest = URLRequest(url: URL(string: "https://jsonplaceholder.typicode.com/posts/1")!)
            
             urlRequest.addValue("application/json", forHTTPHeaderField: "Content-Type")
             
             urlRequest.httpMethod = "DELETE"
            
            URLSession.shared.dataTask(with: urlRequest) { data, response, error in
            guard error == nil else {
                print("Error: error calling DELETE")
                print(error!)
                return
            }
                guard data != nil else {
                print("Error: Did not receive data")
                return
            }
            guard let response = response as? HTTPURLResponse, (200 ..< 299) ~= response.statusCode else {
                print("Error: HTTP request failed")
                return
            }
            do {
                guard let jsonObject = try JSONSerialization.jsonObject(with: (data ?? data)!) as? [String: Any] else {
                    print("Error: Cannot convert data to JSON")
                    return
                }
                guard let prettyJsonData = try? JSONSerialization.data(withJSONObject: jsonObject, options: .prettyPrinted) else {
                    print("Error: Cannot convert JSON object to Pretty JSON data")
                    return
                }
                guard let prettyPrintedJson = String(data: prettyJsonData, encoding: .utf8) else {
                    print("Error: Could print JSON in String")
                    return
                }
                
                print(prettyPrintedJson)
            } catch {
                print("Error: Trying to convert JSON data to string")
                return
            }
            }.resume()
        
    }
    
}


protocol PetsAPI {
    
    //PET
    func postPet()
    func putPet()
    func getPet()
    
}

extension Network : PetsAPI {
    
    func postPet() {
        
    }
    
    func putPet() {
        
    }
    
    func getPet() {
        
    }
    
}

protocol PicsumAPI {
    
    func getPhoto(completionHandler: @escaping (_ data: Data) -> Any)
    
}


