//
//  UdacityClient.swift
//  On the Mapp
//
//  Created by Simon Wells on 2020/11/20.
//

import Foundation

class UdacityClient {
    
    struct Auth {
        static var sessionId: String?
        static var key = ""
        static var firstName = ""
        static var lastName = ""
        static var objectId = ""
        static var uniqueKey = ""
    }
    
    enum Endpoints {
        
        static let base = "https://onthemap-api.udacity.com/v1"
         
        case udacitySignUp
        case login
        case addStudentLocation
        case gettingStudentLocations
        case updateStudentLocation
        case getLoggedInUserProfile
        case logout
        
        var stringValue: String {
            switch self {
            case .udacitySignUp:
                return "https://auth.udacity.com/sign-up"
            case .login:
                return Endpoints.base + "/session"
            case .addStudentLocation:
                return Endpoints.base + "/StudentLocation"
            case .gettingStudentLocations:
                return Endpoints.base + "/StudentLocation"
            case .updateStudentLocation:
                return Endpoints.base + "/StudentLocation/8ZExGR5uX8"
            case .logout:
                return Endpoints.base + "/session"
            case .getLoggedInUserProfile:
                return Endpoints.base + "/users/" + Auth.key
            }
        }
        var url: URL {
        return URL(string: stringValue)!
    }
    }
        
    
    class func login(username: String, password: String, completion: @escaping (Bool, Error?) -> Void) {
        
        
        let body = WrapperLoginRequest(udacity: LoginRequest(username: username, password: password))
        
        RequestHelpers.taskForPOSTRequest(url: UdacityClient.Endpoints.login.url, apiType: "Udacity", responseType: LoginResponse.self, body: body, httpMethod: "Post") { (response, error) in
            if let response = response {
                completion(true, nil)
            }
            if let error = error {
                completion(false, error)
            }else {
                completion(false, error)
            }
                
            }
    }
        
        
        

        /*let body = WrapperLoginRequest(udacity: LoginRequest(username: username, password: password))
RequestHelpers.taskForPOSTRequest(url: Endpoints.login.url, apiType: "Udacity", responseType: LoginResponse.self, body: body, httpMethod: "POST") { (response, error)  in
            if let response = response {
                print ("error is here")
                Auth.sessionId = response.session.id
                Auth.key = response.account.key
                getLoggedInUserProfile(completion: { (success, error) in
                    if success {
                        print ("Logged in user's profile fetched.")
                    }
                })
                completion(true, nil)
            } else {
                completion (false, nil)
                print ("error")
                
            }
    
    }
        
}
    */
    
    class func studentsLocation(completion: @escaping ([StudentLocations]?, Error?) -> Void) {
        let task = URLSession.shared.dataTask(with: Endpoints.gettingStudentLocations.url) { (data, response, error) in
            guard let data = data else {
                DispatchQueue.main.async {
                    completion (nil, error)
                }
                return
            }
            let decoder = JSONDecoder()
            
            do{
                let response = try
                    decoder.decode(StudentLocation.self, from: data)
                DispatchQueue.main.async {
                    completion(response.results, nil)
                }
            } catch {
            
                DispatchQueue.main.async {
                    completion (nil, error)
                }
                }
        }
        task.resume()
}
    

    class func addStudentLocation(information: StudentInformation, completion: @escaping (Bool, Error?) -> Void) {
        var request = URLRequest(url: Endpoints.addStudentLocation.url)
        request.httpMethod = "POST"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpBody = "{\"uniqueKey\": \"1234\", \"firstName\": \"John\", \"lastName\": \"Doe\",\"mapString\": \"Mountain View, CA\", \"mediaURL\": \"https://udacity.com\",\"latitude\": 37.386052, \"longitude\": -122.083851}".data(using: .utf8)
        let session = URLSession.shared
        let task = session.dataTask(with: request) {data, response, error in
            if error != nil {
                completion (false, error)
                return
            }
            print (String(data: data!, encoding: .utf8)!)
            completion(true, nil)
        }
        task.resume()
}
    
    class func updateStudentLocation(information: StudentInformation, completion: @escaping (Bool, Error?) -> Void) {
        var request = URLRequest(url: Endpoints.updateStudentLocation.url)
        request.httpMethod = "PUT"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpBody = "{\"uniqueKey\": \"1234\", \"firstName\": \"John\", \"lastName\": \"Doe\",\"mapString\": \"Cupertino, CA\", \"mediaURL\": \"https://udacity.com\",\"latitude\": 37.322998, \"longitude\": -122.032182}".data(using: .utf8)
        let session = URLSession.shared
        let task = session.dataTask(with: request) { data, response, error in
            if error != nil {
                completion (false, error)
                return
            }
            print (String(data: data!, encoding: .utf8)!)
    }
        task.resume()
}
    
    
    class func logout(completion: @escaping (Bool, Error?) -> Void) {
        var request = URLRequest(url: Endpoints.logout.url)
        request.httpMethod = "DELETE"
        var xsrfCookie: HTTPCookie? = nil
        let sharedCookieStorage = HTTPCookieStorage.shared
        for cookie in sharedCookieStorage.cookies! {
            if cookie.name == "XSRF-TOKEN" { xsrfCookie = cookie }
        }
        if let xsrfCookie = xsrfCookie {
            request.setValue(xsrfCookie.value, forHTTPHeaderField: "X-XSRF-TOKEN")
        }
        let session = URLSession.shared
        let task = session.dataTask(with: request) { data, response, error in
            if error != nil {
            completion (false, error) 
            return
    }
        let range = 5..<data!.count
            let newData = data?.subdata(in: range)
            print (String(data: newData!, encoding: .utf8)!)
            Auth.sessionId = ""
            completion(false, error)
        }
        
        task.resume()
            
        
}
    
    class func getLoggedInUserProfile(completion: @escaping (Bool, Error?) -> Void) {
        RequestHelpers.taskForGetRequest(url: Endpoints.getLoggedInUserProfile.url, apiType: "Udacity", responseType: UserProfile.self) { (response, error ) in
            if let response = response {
            print ("First Name : \(response.firstName) && Last Name : \(response.lastName) && Full Name: \(response.nickname)")
                Auth.firstName = response.firstName
                Auth.lastName = response.lastName
                completion (true, nil)
                
            } else {
                print ("Failed to get user's profile")
                completion (false, error)
            }
        
    }
    }
}
