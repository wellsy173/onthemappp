//
//  RequestHelpers.swift
//  On the Mapp
//
//  Created by Simon Wells on 2020/11/20.
//

import Foundation

class RequestHelpers {

class func taskForGetRequest<ResponseType: Decodable>(url: URL, apiType: String, responseType:  ResponseType.Type, completion: @escaping (ResponseType?, Error?) -> Void) {
    let task = URLSession.shared.dataTask(with: url) { data, response, error in
               guard let data = data else {
                   DispatchQueue.main.async {
                       completion(nil, error)
                   }
                   return
}
        let decoder = JSONDecoder()
        do{
            let responseObject = try decoder.decode(ResponseType.self, from: data)
            DispatchQueue.main.async {
                completion(responseObject, nil)
            }
        } catch {
            do {
                let errorResponse = try decoder.decode(ErrorResponse.self, from: data) as! Error
                DispatchQueue.main.async {
                    completion((errorResponse as! ResponseType), nil)
                }
            } catch {
                DispatchQueue.main.async {
                    completion(nil, error)
                }
            }
            }
        }
    task.resume()
}
    
    class func taskForPOSTRequest<RequestType: Encodable, ResponseType: Decodable>(url: URL, apiType: String, responseType: ResponseType.Type, body: RequestType, httpMethod: String, completion: @escaping (ResponseType?, Error?) -> Void) {
            var request = URLRequest(url: url)
            request.httpMethod = "POST"
            request.httpBody = try! JSONEncoder().encode(body)
            request.addValue("application/json", forHTTPHeaderField: "Content-Type")
            let task = URLSession.shared.dataTask(with: request) { data, response, error in
                if error != nil {
                    completion(nil, error)
                    print(error)
                    return
                }
                
                let range = 5..<data!.count
                let newData = data?.subdata(in: range)
                guard let data = data else {
                    DispatchQueue.main.async {
                        completion(nil, error)
                    }
                    return
                }
                let decoder = JSONDecoder()
                do {
                    let responseObject = try decoder.decode(responseType.self, from: newData!)
                    DispatchQueue.main.async {
                        completion(responseObject, nil)
                    }
                }catch{
                    do {
                        print(String(data: newData!, encoding: .utf8)!)
                        
                        let errorResponse = try decoder.decode(ErrorResponse.self, from: newData!)
                        
                        DispatchQueue.main.async {
                            completion((errorResponse as! ResponseType), nil)
                        }
                    }catch {
                        DispatchQueue.main.async {
                            completion(nil, error)
                            
                            
                        }
                    }
                }
            }
            task.resume()
        }
    }
    
