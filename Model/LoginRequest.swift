//
//  LoginRequest.swift
//  On the Mapp
//
//  Created by Simon Wells on 2020/11/20.
//

import Foundation

struct LoginRequest: Codable {
    
        let username: String
        let password: String
        
        enum CodingKeys: String, CodingKey {
            case username
            case password
        }
    }
    
    struct WrapperLoginRequest: Codable {
        let udacity: LoginRequest
        
        enum CodingKeys: String, CodingKey{
            case udacity
    }
}
